# encoding: utf-8
module Protocop
  module Fields

    # Encapsulates behaviour for bytes fields in the message.
    #
    # @since 0.0.0
    class Bytes
      include LengthDelimited

      # Encode the field to the buffer with the provided value.
      #
      # @example Encode the field.
      #   field.encode_pair(buffer, "\x00\x00")
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ String ] value The bytes value to write.
      #
      # @return [ Buffer ] The buffer that was written to.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def encode_pair(buffer, value)
        buffer.write_varint(key).write_uint64(value.length).write_bytes(value)
      end

      # Encode the field to the buffer packed.
      #
      # @example Encode the packed repeated field.
      #   field.encode_packed(buffer, [ "\x00" ])
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Array<String> ] values The values to write.
      #
      # @return [ Buffer ] The buffer.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#optional
      #
      # @since 0.0.0
      def encode_packed(buffer, values)
        with_packing(buffer, values) { |value, buff| buff.write_bytes(value) }
      end
    end
  end
end
