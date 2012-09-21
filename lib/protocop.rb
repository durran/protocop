# encoding: utf-8
require "protocop/ext"
require "protocop/message"
require "protocop/version"

if ENV["PROTOCOP"] == "noext"
  require "protocop/buffer"
else
  begin
    require "./ext/protocop"
  rescue Exception => e
    require "protocop/buffer"
  end
end
