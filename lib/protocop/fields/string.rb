# encoding: utf-8
module Protocop
  module Fields
    class String

      def encode(outbound, value)
        outbound << value.length.varint << value
      end
    end
  end
end
