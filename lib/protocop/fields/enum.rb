# encoding: utf-8
module Protocop
  module Fields

    # Encapsulates behaviour for enum fields in the message.
    #
    # @since 0.0.0
    class Enum
      include Varint

      # Encode the field to the buffer with the provided value.
      #
      # @example Encode the field.
      #   field.encode_pair(buffer, Type::QUERY)
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Integer ] value The enum int value to write.
      #
      # @return [ Buffer ] The buffer that was written to.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def encode_pair(buffer, value)
        buffer.write_varint(key).write_int32(value)
      end

      # Encode the field to the buffer packed.
      #
      # @example Encode the packed repeated field.
      #   field.encode_packed(buffer, [ 1, 2 ])
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Array<Integer> ] values The values to write.
      #
      # @return [ Buffer ] The buffer.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#optional
      #
      # @since 0.0.0
      def encode_packed(buffer, values)
        with_packing(buffer, values) { |value, buff| buff.write_int32(value) }
      end
    end
  end
end
