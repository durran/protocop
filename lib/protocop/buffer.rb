# encoding: utf-8
module Protocop

  # Encapsulates behaviour for writing to a string of bytes that conforms to
  # the Protocol Buffer wire protocol.
  #
  # @since 0.0.0
  class Buffer

    # Constant for binary string encoding.
    BINARY = "BINARY"

    # @attribute [r] bytes The wrapped string of bytes.
    attr_reader :bytes

    # Check if this buffer is equal to the other object. Simply checks the
    # bytes against the other's bytes.
    #
    # @example Check buffer equality.
    #   buffer == other
    #
    # @param [ Object ] other The object to check against.
    #
    # @return [ true, false ] If the buffer is equal to the object.
    #
    # @since 0.0.0
    def ==(other)
      bytes == other.bytes
    end

    # Instantiate a new buffer.
    #
    # @example Instantiate the buffer.
    #   Protocop::Buffer.new
    #
    # @since 0.0.0
    def initialize
      @bytes = "".force_encoding(BINARY)
    end

    # Write a boolean to the buffer.
    #
    # @example Write a true value to the buffer.
    #   buffer.write_boolean(true)
    #
    # @param [ true, false ] value The boolean value.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_boolean(value)
      write_uint64(value ? 1 : 0)
    end


    # Write a 32bit float to the buffer.
    #
    # @example Write the float to the buffer.
    #   buffer.write_float(1.22)
    #
    # @param [ Float ] value The float value.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_float(value)
      bytes << [ value ].pack("e")
      self
    end

    def write_int32(value)
      write_uint64(value)
    end

    def write_int64(value)
      write_uint64(value)
    end

    def write_sint32(value)
      write_uint64(value)
    end

    def write_sint64(value)
      write_uint64(value)
    end

    def write_uint32(value)
      write_uint64(value)
    end

    def write_uint64(value)
      write_varint(value)
    end

    # Write a varint to the buffer.
    #
    # @example Write a varint.
    #   buffer.write_varint(10)
    #
    # @param [ Integer ] value The integer to write.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding#varints
    #
    # @since 0.0.0
    def write_varint(value)
      while (value > 0x7F) do
        bytes << ((value & 0x7F) | 0x80)
        value >>= 7
      end
      bytes << (value & 0x7F)
      self
    end

    # Write a string to the buffer via the Protocol Buffer specification.
    #
    # @example Write a string to the buffer.
    #   buffer.write_string("test")
    #
    # @param [ String ] value The string to write.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_string(value)
      bytes << value.to_s and self
    end
    alias :write_bytes :write_string
  end
end
