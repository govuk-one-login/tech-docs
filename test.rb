require 'html-proofer'

class BrokenLinkPartialReferences < ::HTMLProofer::Check
  def run
    @html.css('p').each do |node|
      broken_link_match = node.to_s.match(/\[.+\]/)

      if broken_link_match
        add_issue("Broken partial link: " + broken_link_match[0], line: node.line)
      end
    end
  end
end
