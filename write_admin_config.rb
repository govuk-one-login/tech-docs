require 'yaml'
require 'date'
require 'pry'

# Static widget fields
FIELDS = [
  { name: "title", label: "Title", widget: "string" },
  { name: "weight", label: "Weight", widget: "number" },
  { name: "last_reviewed_on", label: "Last Reviewed On", widget: "datetime" },
  { name: "review_in", label: "Review In", widget: "string" },
  { name: "body", label: "Body", widget: "markdown" }
]

VALID_EXTENSIONS = %w[.md .html .erb]

SOURCE_FOLDER = "source"
SITE_LIVE_URL = "https://docs.sign-in.service.gov.uk/"
REPO = "govuk-one-login/tech-docs"
TARGET_BRANCH = "main"

def parse_file_tree
  files_config = []

  # Traverse the directory for Markdown files
  Dir.glob("#{SOURCE_FOLDER}/**/*.{md,erb,html}").each do |file_path|
    files_config << build_file_entry(file_path)
  end

  generate_config(files_config)
end

def build_file_entry(file_path)
  # Only process files with valid extensions
  return nil unless VALID_EXTENSIONS.include?(File.extname(file_path))

  {
    name: get_title_from_file(file_path),
    label: humanize_label_from_path(file_path), # Human-readable label
    file: relative_path(file_path),
    fields: FIELDS
  }
end

def humanize_label_from_path(string)
  string
    .split("/")[-2..-1].join(" | ")
    .split(".").first
    .gsub("-", " ")
    .capitalize
end

def extract_frontmatter(file_path)
  # Read the entire file content
  file_content = File.read(file_path)

  if file_content.include?('---\n')
    # Split the content by the first '---' line (frontmatter delimiter)
    parts = file_content.split('---\n', 3)

    # If there are at least two '---' (frontmatter and content), process the frontmatter
    if parts.size >= 3
      frontmatter = YAML.safe_load(parts[1].strip, permitted_classes: [Date]) # Parse the YAML frontmatter
      return frontmatter
    end
  end


  return {
    "title" => humanize_label_from_path(file_path)
  }
end


def get_title_from_file(file_path)
  extract_frontmatter(file_path)["title"]
end

def generate_config(files_config)
  config = {
    **default_config,
    collections: [
      {
        name: "pages",
        label: "Pages",
        files: files_config
      }
    ]
  }
  # Convert all keys in the hash to strings
  stringified_config = deep_stringify_keys(config)

  # Write YAML
  File.write("#{SOURCE_FOLDER}/config.yml", stringified_config.to_yaml)

  puts "#{files_config.count} files added to config.yml"
end

def default_config
  {
    publish_mode: "editorial_workflow",
    site_url: SITE_LIVE_URL,
    backend: {
      name: "github",
      repo: REPO,
      branch: TARGET_BRANCH,
    },
    media_folder: "/public",
    public_folder: "/public",
  }
end

def deep_stringify_keys(obj)
  case obj
  when Hash
    obj.transform_keys(&:to_s).transform_values { |v| deep_stringify_keys(v) }
  when Array
    obj.map { |v| deep_stringify_keys(v) }
  else
    obj
  end
end

def relative_path(global_path)
  File.join(SOURCE_FOLDER, global_path.split(SOURCE_FOLDER).last)
end

# Base path calculation
puts "Exploring files in: #{SOURCE_FOLDER}/"

parse_file_tree()