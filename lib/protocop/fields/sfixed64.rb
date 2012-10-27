# encoding: utf-8
module Protocop
  module Fields

    # Encapsulates behaviour for sfixed64 fields in the message.
    #
    # @since 0.0.0
    class Sfixed64
      include Bit64

      # Encode the field to the buffer with the provided value.
      #
      # @example Encode the field.
      #   field.encode(buffer, 16)
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Integer ] value The sfixed64 value to write.
      #
      # @return [ Buffer ] The buffer that was written to.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def encode(buffer, value)
        buffer.write_varint(key).write_sfixed64(value)
      end
    end
  end
end
