require "rake"

desc "Generate a compliance-friendly markdown resume"
task :markdown_resume do
  ruby "scripts/build_resume_md.rb"
end

desc "Generate markdown resume and build the Jekyll site"
task build: :markdown_resume do
  sh "bundle exec jekyll build"
end
