# encoding: utf-8
module Protocop
  module Ext

    # Provides convenience extensions to the core Fixnum class.
    module Fixnum

      def varint
        varint_bytes(self)
      end

      private

      def varint_bytes(bytes = "", value)
        bits = value & 0x7F
        value >>= 7
        if value.zero?
          bytes << bits
        else
          bytes << (bits | 0x80) and varint_bytes(bytes, value)
        end
      end
    end
  end
end

Fixnum.__send__(:include, Protocop::Ext::Fixnum)
