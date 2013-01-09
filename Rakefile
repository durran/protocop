require "bundler"
Bundler.setup

require "rake"
require "rspec/core/rake_task"
require_relative "perf/bench"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "protocop/version"

task :gem => :build
task :build do
  system "gem build protocop.gemspec"
end

task :install => :build do
  system "sudo gem install protocop-#{Protocop::VERSION}.gem"
end

def extension
  RUBY_PLATFORM =~ /darwin/ ? "bundle" : "so"
end

def compile!
  puts "Compiling native extensions..."
  Dir.chdir(Pathname(__FILE__).dirname + "ext/protocop") do
    `bundle exec ruby extconf.rb`
    `make`
    `cp native.#{extension} ../../lib/protocop`
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
  begin
    Dir.chdir(Pathname(__FILE__).dirname + "lib/protocop") do
      `rm native.#{extension}`
    end
  rescue Exception => e
    puts e.message
  end
end

namespace :benchmark do

  task :ruby => :clean do
    puts "Benchmarking pure Ruby..."
    load "protocop.rb"
    benchmark!
  end

  task :c => :compile do
    puts "Benchmarking with C extensions..."
    load "protocop.rb"
    benchmark!
  end
end

task :default => [ :compile, :spec, :clean, :clean_spec ]
task :bench => [ "benchmark:ruby", "benchmark:c" ]
