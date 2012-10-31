# encoding: utf-8
module Protocop
  module Fields

    # Field definition macros are provided in this module.
    #
    # @since 0.0.0
    module Macros

      # Get a Protocol Buffer field instance for this module.
      #
      # @example Get a field instance.
      #   Request::Type.__protofield__(Request::Type, :count, 1)
      #
      # @param [ Module ] type The field's type.
      # @param [ Symbol ] name The name of the field.
      # @param [ Integer ] number The number of the field.
      # @param [ Hash ] options The field options.
      #
      # @option :options [ Integer ] :default The default enumeration value.
      #
      # @return [ Fields::Frame ] The field instance.
      #
      # @since 0.0.0
      def __protofield__(type, name, number, options = {})
        Fields::Embedded.new(type, name, number, options)
      end

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
      # @example Define a required field.
      #   class Request
      #     include Protocop::Message
      #     required :string, :name, 1
      #   end
      #
      # @example Define a required enum field.
      #   class Request
      #     include Protocop::Message
      #     module Type
      #       QUERY = 0
      #       COUNT = 1
      #     end
      #     required Type, :type, 1, default: Type::QUERY
      #   end
      #
      # @param [ Symbol ] type The field's type.
      # @param [ Symbol ] name The name of the field.
      # @param [ Integer ] number The field's identifier for encoding/decoding.
      #
      # @since 0.0.0
      def required(type, name, number, options = {})
        fields[name] = type.__protofield__(type, name, number, options)
        attr_accessor(name)
      end
    end
  end
end
