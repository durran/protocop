# encoding: utf-8
require "protocop/fields"
require "protocop/wire"

module Protocop

  # A Message is simply an encodable structure that conforms to Google's
  # Protocol Buffer specification.
  #
  # @see http://code.google.com/p/protobuf/
  #
  # @since 0.0.0
  module Message
    include Fields

    # Encode the message to the provided buffer or use a new one.
    #
    # @example Encode the message.
    #   message.encode
    #
    # @param [ Buffer ] buffer The buffer to encode the message to.
    #
    # @return [ Buffer ] The encoded buffer.
    #
    # @since 0.0.0
    def encode(buffer = Buffer.new)
      fields.values.each do |field|
        field.encode(buffer, __send__(field.name))
      end
      return buffer
    end

    # Instantiate a new Message. If no attributes are provided, then the fields
    # will need to be set using the setters, otherwise the provided attributes
    # must be a hash of field/value pairs.
    #
    # @example Instantiate a Message with some fields.
    #   class Request
    #     include Protocop::Message
    #     optional :string, :name, 1
    #   end
    #
    #   Request.new(name: "request message")
    #
    # @param [ Hash ] attributes The field/value attribute pairs.
    #
    # @since 0.0.0
    def initialize(attributes = {})
      attributes.each_pair do |field, value|
        __send__(field.__setter__, value)
      end
    end

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
      klass.extend(Fields::Macros)
    end
  end
end
