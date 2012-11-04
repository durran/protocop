# encoding: utf-8
module Protocop
  module Fields

    # Encapsulates behaviour for uint64 fields in the message.
    #
    # @since 0.0.0
    class Uint64
      include Varint

      # Encode the field to the buffer with the provided value.
      #
      # @example Encode the field.
      #   field.encode_one(buffer, 16)
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Integer ] value The uint64 value to write.
      #
      # @return [ Buffer ] The buffer that was written to.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def encode_one(buffer, value)
        buffer.write_varint(key).write_uint64(value)
      end
    end
  end
end
