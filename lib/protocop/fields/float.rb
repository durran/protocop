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
      #   field.encode_pair(buffer, 123.45)
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Float ] value The float value to write.
      #
      # @return [ Buffer ] The buffer that was written to.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def encode_pair(buffer, value)
        buffer.write_varint(key).write_float(value)
      end

      # Encode the field to the buffer packed.
      #
      # @example Encode the packed repeated field.
      #   field.encode_packed(buffer, [ 1.1112, 2.12 ])
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Array<Float> ] values The values to write.
      #
      # @return [ Buffer ] The buffer.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#optional
      #
      # @since 0.0.0
      def encode_packed(buffer, values)
        with_packing(buffer, values) { |value, buff| buff.write_float(value) }
      end
    end
  end
end
