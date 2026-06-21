require_relative './constants'

require 'mactor'
require 'yaml'
require 'erb'
require 'fileutils'

module BasicModule
  def run
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    super
    elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
    puts "Build finished in %.3fs" % elapsed
  end

  def files = Dir.children(Constants::APP_DIR)

  def process_file(input_path)
    data, body = parse_frontmatter(File.read(File.join(Constants::APP_DIR, input_path)))
    title   = data["title"]
    date    = data["date"]
    content = Mactor.to_html(body)
    html    = ERB.new(Constants::TEMPLATE).result(binding)
    write_html(File.basename(input_path, ".md"), html)
  end

  def parse_frontmatter(content)
    if content.start_with?("---")
      parts = content.split("---", 3)
      [YAML.load(parts[1]), parts[2].strip]
    else
      [YAML.load(""), content]
    end
  end

  def write_html(slug, html)
    FileUtils.mkdir_p(Constants::OUTPUT_DIR)
    File.write(File.join(Constants::OUTPUT_DIR, "#{slug}.html"), html)
  end

  module_function :process_file, :parse_frontmatter, :write_html
end
