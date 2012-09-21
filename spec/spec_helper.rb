$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

ENV["PROTOCOP"] ||= "noext"

require "protocop"
require "rspec"
