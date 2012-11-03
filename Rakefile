require "bundler"
Bundler.setup

require "rake"
require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "protocop/version"

task :gem => :build
task :build do
  system "gem build protocop.gemspec"
end

task :install => :build do
  system "sudo gem install protocop-#{Protocop::VERSION}.gem"
end

task :release => :build do
  system "git tag -a v#{Protocop::VERSION} -m 'Tagging #{Protocop::VERSION}'"
  system "git push --tags"
  system "gem push protocop-#{Protocop::VERSION}.gem"
  system "rm protocop-#{Protocop::VERSION}.gem"
end

RSpec::Core::RakeTask.new("spec") do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

RSpec::Core::RakeTask.new("spec:ext") do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

def compile
  Dir.chdir(Pathname(__FILE__).dirname + "ext") do
    `bundle exec ruby extconf.rb`
    `make`
  end
end

task :full do
  ENV["PROTOCOP"] = "noext"
  Rake::Task[:spec].invoke
  ENV["PROTOCOP"] = "ext"
  compile
  Rake::Task[:"spec:ext"].invoke
end

task :default => :full
