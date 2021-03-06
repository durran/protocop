# encoding: utf-8
module Protocop
  module Fields

    # Encapsulates behaviour for string fields in the message.
    #
    # @since 0.0.0
    class String
      include LengthDelimited

      # Encode the field to the buffer with the provided single value.
      #
      # @example Encode the field.
      #   field.encode_pair(buffer, "test")
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ String ] value The string value to write.
      #
      # @return [ Buffer ] The buffer that was written to.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def encode_pair(buffer, value)
        buffer.write_varint(key).write_string(value)
      end
    end
  end
end
