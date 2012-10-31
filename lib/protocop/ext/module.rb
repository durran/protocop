# encoding: utf-8
module Protocop
  module Ext

    # Provides convenience extensions to the core Module class.
    #
    # @since 0.0.0
    module Module

      # Get a Protocol Buffer field instance for this module.
      #
      # @api private
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
        Fields::Enum.new(type, name, number, options)
      end
    end
  end
end

Module.__send__(:include, Protocop::Ext::Module)
