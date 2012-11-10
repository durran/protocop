# encoding: utf-8
module Protocop
  module Fields

    # Encapsulates behaviour for boolean fields in the message.
    #
    # @since 0.0.0
    class Boolean
      include Varint

      # Encode the field to the buffer with the provided value.
      #
      # @example Encode the field.
      #   field.encode_pair(buffer, true)
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ true, false ] value The boolean value to write.
      #
      # @return [ Buffer ] The buffer that was written to.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def encode_pair(buffer, value)
        buffer.write_varint(key).write_boolean(value)
      end

      # Encode the field to the buffer packed.
      #
      # @example Encode the packed repeated field.
      #   field.encode_packed(buffer, [ true, false ])
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Array<true, false> ] values The values to write.
      #
      # @return [ Buffer ] The buffer.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#optional
      #
      # @since 0.0.0
      def encode_packed(buffer, values)
        with_packing(buffer, values) { |value, buff| buff.write_boolean(value) }
      end
    end
  end
end
