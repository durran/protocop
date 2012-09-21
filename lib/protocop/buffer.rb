# encoding: utf-8
module Protocop

  # Encapsulates behaviour for writing to a string of bytes that conforms to
  # the Protocol Buffer wire protocol.
  #
  # @since 0.0.0
  class Buffer

    # @attribute [r] bytes The wrapped string of bytes.
    attr_reader :bytes

    # Check if this buffer is equal to the other object. Simply checks the
    # bytes against the other's string representation.
    #
    # @example Check buffer equality.
    #   buffer == "testing"
    #
    # @param [ Object ] other The object to check against.
    #
    # @return [ true, false ] If the buffer is equal to the object.
    #
    # @since 0.0.0
    def ==(other)
      to_s == other.to_s
    end

    # Instantiate a new buffer. Will default to empty bytes if no parameter
    # provided.
    #
    # @example Instantiate the buffer.
    #   Protocop::Buffer.new
    #
    # @param [ String ] bytes The bytes to wrap.
    #
    # @since 0.0.0
    def initialize(bytes = "")
      @bytes = bytes
    end

    # Alias to_s simply to the wrapped bytes string.
    #
    # @example Get the buffer as a string.
    #   buffer.to_s
    #
    # @return [ String ] The wrapped bytes.
    #
    # @since 0.0.0
    alias :to_s :bytes

    # Write a variable length integer to the protocol buffer.
    #
    # @example Write a varint.
    #   buffer.write_varint(10)
    #
    # @note This is a recursive function that will return the buffer when
    #   finished.
    #
    # @param [ Integer ] value The integer to write.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding#varints
    #
    # @since 0.0.0
    def write_varint(value)
      bits = value & 0x7F
      value >>= 7
      if value == 0
        bytes << bits and self
      else
        bytes << (bits | 0x80)
        write_varint(value)
      end
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
  end
end
