# encoding: utf-8
module Protocop
  module Fields

    # Encapsulates behaviour for float fields in the message.
    #
    # @since 0.0.0
    class Float
      include Bit32

      # Encode the field to the buffer with the provided value.
      #
      # @example Encode the field.
      #   field.encode_one(buffer, 123.45)
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Float ] value The float value to write.
      #
      # @return [ Buffer ] The buffer that was written to.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def encode_one(buffer, value)
        buffer.write_varint(key).write_float(value)
      end
    end
  end
end
