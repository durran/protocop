# encoding: utf-8
module Protocop
  module Ext

    # Provides convenience extensions to the core Class class.
    #
    # @since 0.0.0
    module Class

      # Get a Protocol Buffer field instance for this class.
      #
      # @example Get a field instance.
      #   Command.__protofield__(Command, :count, 1)
      #
      # @param [ Class ] type The field's type.
      # @param [ Symbol ] name The name of the field.
      # @param [ Integer ] number The number of the field.
      # @param [ Hash ] options The field options.
      #
      # @return [ Fields::Frame ] The field instance.
      #
      # @since 0.0.0
      def __protofield__(type, name, number, options = {})
        Fields::Embedded.new(type, name, number, options)
      end
    end
  end
end

Class.__send__(:include, Protocop::Ext::Class)
