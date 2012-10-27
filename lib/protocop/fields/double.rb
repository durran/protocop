# encoding: utf-8
module Protocop
  module Fields

    # Encapsulates behaviour for double fields in the message.
    #
    # @since 0.0.0
    class Double
      include Bit64

      # Encode the field to the buffer with the provided value.
      #
      # @example Encode the field.
      #   field.encode(buffer, 123.45)
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Float ] value The double value to write.
      #
      # @return [ Buffer ] The buffer that was written to.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def encode(buffer, value)
        buffer.write_varint(key).write_double(value)
      end
    end
  end
end
