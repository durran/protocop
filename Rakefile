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

def compile!
  puts "Compiling native extensions..."
  Dir.chdir(Pathname(__FILE__).dirname + "ext/protocop") do
    `bundle exec ruby extconf.rb`
    `make`
    `cp native.bundle ../../lib/protocop`
  end
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

RSpec::Core::RakeTask.new("clean_spec") do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :compile do
  compile!
end

task :clean do
  puts "Cleaning out native extensions..."
  Dir.chdir(Pathname(__FILE__).dirname + "lib/protocop") do
    `rm native.bundle`
  end
end

task :default => [ :compile, :spec, :clean, :clean_spec ]
