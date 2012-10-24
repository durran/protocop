# encoding: utf-8
module Protocop
  module Fields
    class String
      include Frame

      # Encode the field to the buffer with the provided value.
      #
      # @example Encode the field.
      #   field.encode(buffer, "test")
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ String ] value The string value to write.
      #
      # @return [ Buffer ] The buffer that was written to.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def encode(buffer, value)
        buffer.write_int32(key).write_uint64(value.length).write_string(value)
      end

      # Get the key for this field instance.
      #
      # @example Get the key for the field.
      #   field.key
      #
      # @return [ Integer ] The key as a single byte.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def key
        (number << 3) | Wire::LENGTH
      end
    end
  end
end
