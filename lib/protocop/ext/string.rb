# encoding: utf-8
module Protocop
  module Ext

    # Provides convenience extensions to the core String class.
    module String

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
