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
      #   macros.fields
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
      # @example Define an embedded message field.
      #   class Command
      #     include Protocop::Message
      #     required :string, :name, 1
      #   end
      #
      #   class Request
      #     include Protocop::Message
      #     required Command, :command, 2
      #   end
      #
      # @param [ Class, Module, Symbol ] type The field's type.
      # @param [ Symbol ] name The name of the field.
      # @param [ Integer ] number The field's identifier for encoding/decoding.
      # @param [ Hash ] options The field options.
      #
      # @option options [ Integer ] :default The default value.
      #
      # @since 0.0.0
      def required(type, name, number, options = {})
        frame_opts = options.merge(required: true)
        fields[name] = type.__protofield__(type, name, number, frame_opts)
        field_accessors(name)
      end

      private

      # Define the accessors (getter and setter) for the field.
      #
      # @api private
      #
      # @example Define the accessors.
      #   Macros.field_accessors(:name)
      #
      # @param [ Symbol ] name The name of the field.
      #
      # @since 0.0.0
      def field_accessors(name)
        field_reader(name)
        attr_writer(name)
      end

      # Define the reader for the field with the provided name.
      #
      # @api private
      #
      # @example Define the reader.
      #   Macros.field_reader(:name)
      #
      # @param [ Symbol ] name The name of the field.
      #
      # @since 0.0.0
      def field_reader(name)
        class_eval <<-READER
          def #{name}
            @#{name} ||= fields[:#{name}].default
          end
        READER
      end
    end
  end
end
