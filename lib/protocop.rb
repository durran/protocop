# encoding: utf-8
require "protocop/ext"
require "protocop/buffer"
require "protocop/message"
require "protocop/version"

begin
  require "protocop/native"
rescue LoadError
  $stderr.puts("Protocop is using the pure Ruby buffer implementation.")
end
