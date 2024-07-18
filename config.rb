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
    HTMLProofer.check_directory(config[:build_dir],
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
            "https://w3c-ccg.github.io/did-method-web/#read-resolve" # Link works in browser but HTML is, technically, correct the #read-resolve anchor is not present in the HTML but auto-magically added when the page is rendered
        ],
        :swap_urls => { config[:tech_docs][:host] => "" },
        typhoeus: {
            # Some external links need to think you're in a browser to serve non-error codes
            headers: { "User-Agent" => "Mozilla/5.0 (Android 14; Mobile; LG-M255; rv:122.0) Gecko/122.0 Firefox/122.0" }
        }
    }).run
  rescue RuntimeError => e
    abort e.to_s
  end
end
