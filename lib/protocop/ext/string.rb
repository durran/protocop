# encoding: utf-8
module Protocop
  module Ext

    # Provides convenience extensions to the core String class.
    module String

      # Get a Protocol Buffer field instance for this string.
      #
      # @example Get a field instance.
      #   "int32".__protofield__("int32", :count, 1)
      #
      # @param [ String ] type The field's type.
      # @param [ Symbol ] name The name of the field.
      # @param [ Integer ] number The number of the field.
      # @param [ Hash ] options The field options.
      #
      # @return [ Fields::Frame ] The field instance.
      #
      # @since 0.0.0
      def __protofield__(type, name, number, options = {})
        Fields.const_get(capitalize.to_sym).new(type, name, number, options)
      end

      # Get the string as a setter method name.
      #
      # @example Get the string as a setter method name.
      #   "testing".__setter__
      #
      # @return [ String ] The string plus "="
      #
      # @since 0.0.0
      def __setter__
        "#{self}="
      end
    end
  end
end

String.__send__(:include, Protocop::Ext::String)
