# encoding: utf-8
module Protocop
  module Ext

    # Provides convenience extensions to the core Symbol class.
    module Symbol

      # Get the symbol as a setter method name.
      #
      # @example Get the symbol as a setter method name.
      #   "testing".__setter__
      #
      # @return [ String ] The symbol plus "="
      #
      # @since 0.0.0
      def __setter__
        "#{self}="
      end
    end
  end
end

Symbol.__send__(:include, Protocop::Ext::Symbol)
