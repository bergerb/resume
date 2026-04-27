require "fileutils"
require "open3"

def assert(condition, message)
  raise message unless condition
end

def repo_root
  File.expand_path("..", __dir__)
end

def build_site(config_contents: nil)
  output_directory = File.join(repo_root, "_site_test")
  config_override_path = File.join(repo_root, "_test_config_override.yml")

  FileUtils.rm_rf(output_directory)
  FileUtils.rm_f(config_override_path)

  command = "bundle exec jekyll build --source . --destination _site_test"

  if config_contents
    File.write(config_override_path, config_contents)
    command += " --config _config.yml,_test_config_override.yml"
  end

  stdout, stderr, status = Open3.capture3(
    { "BUNDLE_GEMFILE" => File.join(repo_root, "Gemfile") },
    command,
    chdir: repo_root
  )

  assert(status.success?, <<~MESSAGE)
    Expected the resume site build to succeed.
    Command:
    #{command}
    STDOUT:
    #{stdout}
    STDERR:
    #{stderr}
  MESSAGE

  output_directory
ensure
  FileUtils.rm_f(config_override_path)
end

output_directory = build_site(config_contents: <<~YAML)
  avatar_url: "https://example.com/avatar.png"
YAML

html = File.read(File.join(output_directory, "index.html"))

assert(
  html.match?(%r{<div class="hero__media">\s*<img class="hero__avatar" src="https://example.com/avatar\.png" alt="Brent Berger portrait">\s*</div>}m),
  "Expected the home page to render the configured avatar in the hero."
)

puts "PASS"
