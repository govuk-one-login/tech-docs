require 'govuk_tech_docs'

# Check for broken links
require 'html-proofer'
require_relative 'test'

# Pretty URLs see https://middlemanapp.com/advanced/pretty-urls/
activate :directory_indexes

GovukTechDocs.configure(self)

page "/*", :layout => "dicustom_layout"

after_build do |builder|
  begin
    proofer = HTMLProofer.check_directory(config[:build_dir],
      { :assume_extension => true,
        :allow_hash_href => true,
        :ignore_files => [
            /search/ # Provided by tech-docs gem but has a "broken" link from html-proofer's point of view
        ],
        :ignore_urls => [
            /#{Regexp.quote(config[:tech_docs][:github_repo])}/, # Avoid chicken-and-egg problem when new pages in a PR break the link checker
            "https://www.ncsc.gov.uk/collection/cloud/using-cloud-services-securely/using-a-cloud-platform-securely#section_11", # Avoid problem with html proofer not liking this hash even though the actual link with hash exists
            "https://www.royalmail.com/find-a-postcode", # Avoid intermittent 403 errors from the post office that kills the pipeline
            "https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/data-protection-impact-assessments-dpias/", # Avoid flagging checker because of CloudFlare security on site
            "https://w3c-ccg.github.io/did-method-web/#read-resolve", # Link works in browser but HTML is, technically, correct the #read-resolve anchor is not present in the HTML but auto-magically added when the page is rendered
            "https://www.icao.int/publications/Documents/9303_p3_cons_en.pdf", # ICAO site is being migrated so the doc is temporarily unavailable but the resulting page points the user to an alternative
            /https\:\/\/www.sign-in.service.gov.uk/  # SSE / Product pages are currently experiencing issues, which causes this to timeout (requests take over 10 seconds)
        ],
        :swap_urls => { config[:tech_docs][:host] => "" },
        # reduce concurrency to avoid overwhelming external servers
        hydra: { max_concurrency: 1 },
        typhoeus: {
            # Some external links need to think you're in a browser to serve non-error codes
            headers: { "User-Agent" => "Mozilla/5.0 (Android 14; Mobile; LG-M255; rv:122.0) Gecko/122.0 Firefox/122.0" }
        }
    })
    # The snippet below starts a linear backoff delay once requesting the same URL more than once
    # This is to try and prevent too many requests errors
    base_url_regex = /^(https?:\/\/[^\/\s]+)/
    base_url_counts = Hash.new(0);
    proofer.before_request do |request|
      base_url = request.url[base_url_regex]
      if base_url
        count = (base_url_counts[base_url] += 1)
        if count > 1 
          delay = 0.1
          to_sleep = (count - 1) * delay
          puts "Sleeping for #{(to_sleep).round(2)}s as #{base_url} has already been requested #{count} times"
          sleep(to_sleep)
        end
      end
    end
    proofer.run
  rescue RuntimeError => e
    abort e.to_s
  end
end
