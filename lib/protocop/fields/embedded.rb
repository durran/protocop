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
      #   field.encode(buffer, request)
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Message ] value The embedded message to write.
      #
      # @return [ Buffer ] The buffer that was written to.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def encode(buffer, value)
        # buffer.write_varint(key).write_uint64(value.length).write_string(value)
      end
    end
  end
end
