# encoding: utf-8
require "protocop/ext"
require "protocop/message"
require "protocop/version"

begin
  require "./ext/protocop"
rescue Exception => e
  require "protocop/buffer"
end
