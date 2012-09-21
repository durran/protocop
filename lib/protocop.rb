# encoding: utf-8
require "protocop/ext"
require "protocop/message"
require "protocop/version"

begin
  require "/Users/durran/work/oss/protocop/ext/protocop"
rescue Exception => e
  puts(e)
  puts(e.backtrace)
  require "protocop/buffer"
end
