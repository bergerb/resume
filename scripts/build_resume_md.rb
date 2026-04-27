require "yaml"

ROOT = File.expand_path("..", __dir__)
DATA_PATH = File.join(ROOT, "_data", "backpack.yml")
OUTPUT_PATH = File.join(ROOT, "resume-compliance.md")

data = YAML.safe_load(File.read(DATA_PATH), permitted_classes: [], aliases: false)

def wrap_lines(text)
  text.to_s.strip.gsub(/\s+/, " ")
end

def markdown_list(items)
  items.map { |item| "- #{item}" }
end

lines = []

lines << "# #{data.dig('header', 'name')}"
lines << ""
lines << data.dig("header", "title").to_s
lines << ""

contact = data.fetch("contact", []).map { |item| item["text"] }.reject(&:nil?)
unless contact.empty?
  lines << contact.join(" | ")
  lines << ""
end

lines << "## Professional Summary"
lines << ""
lines << wrap_lines(data["summary"])
lines << ""

core_strengths = data.fetch("core_strengths", [])
unless core_strengths.empty?
  lines << "## Core Strengths"
  lines << ""
  lines.concat(markdown_list(core_strengths))
  lines << ""
end

skills = data.fetch("skills", [])
unless skills.empty?
  lines << "## Technical Skills"
  lines << ""
  skills.each do |skill|
    tools = skill.fetch("tools", []).map { |tool| tool["name"] }
    lines << "**#{skill['category']}:** #{tools.join(', ')}"
  end
  lines << ""
end

experiences = data.fetch("experiences", [])
unless experiences.empty?
  lines << "## Professional Experience"
  lines << ""
  experiences.each do |experience|
    lines << "### #{experience['role']} | #{experience['company']}"
    meta = [experience["time"], experience["location"]].compact.join(" | ")
    lines << meta unless meta.empty?
    lines << ""
    lines.concat(markdown_list(experience.fetch("highlights", []).map { |item| wrap_lines(item) }))
    technologies = experience.fetch("technologies", [])
    unless technologies.empty?
      lines << ""
      lines << "**Technologies:** #{technologies.join(', ')}"
    end
    lines << ""
  end
end

education = data.fetch("education", [])
unless education.empty?
  lines << "## Education"
  lines << ""
  education.each do |item|
    lines << "**#{item['university']}**"
    lines << item["degree"].to_s
    lines << item["honors"].to_s unless item["honors"].to_s.empty?
    lines << ""
  end
end

File.write(OUTPUT_PATH, lines.join("\n").rstrip + "\n")
puts "Wrote #{OUTPUT_PATH}"
