# encoding: utf-8
module Protocop
  class Buffer

    attr_reader :bytes

    def initialize(bytes = "")
      @bytes = bytes
    end

    # def varint(bytes = "", value = self)
      # bits = value & 0x7F
      # value >>= 7
      # if value == 0
        # bytes << bits
      # else
        # bytes << (bits | 0x80)
        # varint(bytes, value)
      # end
    # end
  end
end
