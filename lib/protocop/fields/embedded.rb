# encoding: utf-8
module Protocop
  module Fields

    # Encapsulates behaviour for embedded messages.
    #
    # @since 0.0.0
    class Embedded
      include LengthDelimited

      # Encode the field to the buffer with the provided value.
      #
      # @example Encode the field.
      #   field.encode_pair(buffer, request)
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Message ] value The embedded message to write.
      #
      # @return [ Buffer ] The buffer that was written to.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def encode_pair(buffer, value)
        buffer.write_varint(key).write_bytes(value.encode.bytes)
      end

      # Encode the field to the buffer packed.
      #
      # @example Encode the packed repeated field.
      #   field.encode_packed(buffer, [ request ])
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Array<Object> ] values The values to write.
      #
      # @return [ Buffer ] The buffer.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#optional
      #
      # @since 0.0.0
      def encode_packed(buffer, values)
        with_packing(buffer, values) do |value, buff|
          buff.write_bytes(value.encode.bytes)
        end
      end
    end
  end
end
