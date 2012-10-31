# encoding: utf-8
module Protocop
  module Fields

    # Field definition macros are provided in this module.
    #
    # @since 0.0.0
    module Macros

      # Get all the defined fields for the message.
      #
      # @example Get all defined fields.
      #   definitions.fields
      #
      # @return [ Hash ] The fields as name/field pairs.
      #
      # @see https://developers.google.com/protocol-buffers/docs/overview
      #
      # @since 0.0.0
      def fields
        @fields ||= {}
      end

      # Define a required field in the message.
      #
      # @example Define a required field
      #   class Request
      #     include Protocop::Message
      #     required :string, :name, 1
      #   end
      #
      # @param [ Symbol ] type The field's type.
      # @param [ Symbol ] name The name of the field.
      # @param [ Integer ] number The field's identifier for encoding/decoding.
      #
      # @since 0.0.0
      def required(type, name, number)
        fields[name] = Fields.const_get(type.to_s.capitalize.to_sym).new(number)
        attr_accessor(name)
      end
    end
  end
end
