# encoding: utf-8
module Protocop
  module Fields
    class String

      def encode(outbound, value)
        outbound.write_varint64(value.length).write_string(value)
      end
    end
  end
end
