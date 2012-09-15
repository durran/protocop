# encoding: utf-8
module Protocop

  # A Message is simply an encodable structure that conforms to Google's
  # Protocol Buffer specification.
  #
  # @see http://code.google.com/p/protobuf/
  module Message

    private

    # When including the module into a class, we need to inject the class
    # methods for the DSL as well as the instance methods.
    #
    # @example Include the Message module, which extends the DSL.
    #   class Request
    #     include Protocop::Message
    #   end
    #
    # @param [ Class ] klass The class that is including the module.
    #
    # @return [ Class ] The class The included the module.
    #
    # @since 0.0.0
    def self.included(klass)
      klass.extend(DSL)
    end
  end
end
