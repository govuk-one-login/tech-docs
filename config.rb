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
        :empty_alt_ignore => true,
        :file_ignore => [
            /search/ # Provided by tech-docs gem but has a "broken" link from html-proofer's point of view
        ],
        :url_ignore => [
            /#{Regexp.quote(config[:tech_docs][:github_repo])}/ # Avoid chicken-and-egg problem when new pages in a PR break the link checker
        ],
        :url_swap => { config[:tech_docs][:host] => "" },
        typhoeus: {
            # Some external links need to think you're in a browser to serve non-error codes
            headers: { "User-Agent" => "Mozilla/5.0 (Android 12; Mobile; rv:68.0) Gecko/68.0 Firefox/101.0" }
        }
    }).run
  rescue RuntimeError => e
    abort e.to_s
  end
end
