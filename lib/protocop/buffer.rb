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

    # Read a boolen from the buffer, removing the byte from the buffer in the
    # process.
    #
    # @example Read a boolean from the buffer.
    #   buffer.read_boolean
    #
    # @return [ true, false ] value The boolean value.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_boolean
      read(1).ord != 0
    end

    # Read a 64bit double from the buffer, removing the bytes from the buffer
    # in the process.
    #
    # @example Read a double from the buffer.
    #   buffer.read_double
    #
    # @return [ Float ] value The double value.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_double
      decode_double(read(8))
    end

    # Read a fixed size 32 bit integer from the buffer (little endian),
    # removing the bytes from the buffer in the process.
    #
    # @example Read the fixed 32 bit value.
    #   buffer.read_fixed32
    #
    # @return [ Integer ] The integer value.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_fixed32
      read(4).unpack("V")[0]
    end

    # Read a fixed size 64 bit integer from the buffer (little endian),
    # removing the bytes from the buffer in the process.
    #
    # @example Read the fixed 64 bit value.
    #   buffer.read_fixed64
    #
    # @return [ Integer ] The integer value.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_fixed64
      values = read(8).unpack("VV")
      values[0] + (values[1] << 32)
    end

    # Read a 32bit float from the buffer, removing the bytes from the buffer
    # in the process.
    #
    # @example Read a float from the buffer.
    #   buffer.read_float
    #
    # @return [ Float ] value The float value.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_float
      read(4).unpack("e")[0]
    end

    # Read a 32 bit integer from the buffer. The number of bytes that are read
    # will depend on the value of the variable length integer.
    #
    # @example Read the integer from the buffer.
    #   buffer.read_int32
    #
    # @return [ Integer ] The integer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_int32
      read_int64
    end

    # Read a 64 bit integer from the buffer. The number of bytes that are read
    # will depend on the value of the variable length integer.
    #
    # @example Read the integer from the buffer.
    #   buffer.read_int64
    #
    # @return [ Integer ] The integer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_int64
      value = read_varint
      value -= (1 << 64) if value > Integer::MAX_SIGNED_64BIT
      value
    end

    # Read a signed fixed 32 bit integer from the buffer (little endian).
    #
    # @example Read the signed fixed 32 bit value.
    #   buffer.read_sfixed32
    #
    # @return [ Integer ] The integer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_sfixed32
      un_zig_zag(read_fixed32)
    end

    # Read a signed fixed 64 bit integer from the buffer (little endian).
    #
    # @example Read the signed fixed 64 bit value.
    #   buffer.read_sfixed64
    #
    # @return [ Integer ] The integer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_sfixed64
      un_zig_zag(read_fixed64)
    end

    # Read a 32 bit signed integer from the buffer.
    #
    # @example Read the integer from the buffer.
    #   buffer.read_sint32
    #
    # @return [ Integer ] value The integer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_sint32
      un_zig_zag(read_varint)
    end

    # Read a 64 bit signed integer from the buffer.
    #
    # @example Read the integer from the buffer.
    #   buffer.read_sint64
    #
    # @return [ Integer ] value The integer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_sint64
      un_zig_zag(read_varint)
    end

    # Read a string from the buffer.
    #
    # @example Read a string from the buffer.
    #   buffer.read_string
    #
    # @note Will first read a varint length to get the length of the string,
    #   then will read the number of bytes equivalent to the length.
    #
    # @return [ String ] The string.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_string
      read(read_varint)
    end
    alias :read_bytes :read_string

    # Read a 32 bit unsigned integer from the buffer.
    #
    # @example Read the integer from the buffer.
    #   buffer.read_uint32
    #
    # @return [ Integer ] value The integer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_uint32
      read_varint
    end

    # Read a 64 bit unsigned integer from the buffer.
    #
    # @example Read the integer from the buffer.
    #   buffer.read_uint64
    #
    # @return [ Integer ] value The integer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_uint64
      read_varint
    end

    # Read a variable byte length integer from the buffer. The number of bytes
    # that are read will depend on the value of the integer.
    #
    # @example Read the varint from the buffer.
    #   buffer.read_varint
    #
    # @return [ Integer ] The integer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def read_varint
      value, shift = 0, 0
      while (byte = read(1).ord) do
        value |= (byte & 0x7F) << shift
        shift += 7
        return value if (byte & 0x80) == 0
      end
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

    # Write a 64bit double to the buffer.
    #
    # @example Write the double to the buffer.
    #   buffer.write_double(1.22)
    #
    # @param [ Float ] value The double value.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_double(value)
      append_double(value)
    end

    # Write a fixed size 32 bit integer to the buffer (little endian).
    #
    # @example Write the fixed 32 bit value.
    #   buffer.write_fixed32(1000)
    #
    # @param [ Integer ] value The value to write.
    #
    # @raise [ Errors::InvalidInt32 ] If the value is invalid.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_fixed32(value)
      validate_int32!(value)
      append_fixed32(value)
    end

    # Write a fixed size 64 bit integer to the buffer (little endian).
    #
    # @example Write the fixed 64 bit value.
    #   buffer.write_fixed64(1000)
    #
    # @param [ Integer ] value The value to write.
    #
    # @raise [ Errors::InvalidInt64 ] If the value is invalid.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_fixed64(value)
      validate_int64!(value)
      append_fixed64(value)
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
      append_float(value)
    end

    # Write a 32 bit integer to the buffer.
    #
    # @example Write the integer to the buffer.
    #   buffer.write_int32(14)
    #
    # @note If you find you are writing negative numbers more than positive
    #   ones for int32 it is more efficient to be using sint32 instead since
    #   negative int32s will take up more space.
    #
    # @param [ Integer ] value The integer.
    #
    # @raise [ Errors::InvalidInt32 ] If the value is invalid.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_int32(value)
      validate_int32!(value)
      write_varint(value)
    end

    # Write a 64 bit integer to the buffer.
    #
    # @example Write the integer to the buffer.
    #   buffer.write_int64(14)
    #
    # @note If you find you are writing negative numbers more than positive
    #   ones for int64 it is more efficient to be using sint64 instead since
    #   negative int64s will take up more space.
    #
    # @param [ Integer ] value The integer.
    #
    # @raise [ Errors::InvalidInt64 ] If the value is invalid.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_int64(value)
      validate_int64!(value)
      write_varint(value)
    end

    # Write a signed fixed size 32 bit integer to the buffer (little endian).
    #
    # @example Write the signed fixed 32 bit value.
    #   buffer.write_sfixed32(1000)
    #
    # @param [ Integer ] value The value to write.
    #
    # @raise [ Errors::InvalidInt32 ] If the value is invalid.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_sfixed32(value)
      validate_int32!(value)
      write_fixed32(zig_zag32(value))
    end

    # Write a signed fixed size 64 bit integer to the buffer (little endian).
    #
    # @example Write the signed fixed 64 bit value.
    #   buffer.write_sfixed64(1000)
    #
    # @param [ Integer ] value The value to write.
    #
    # @raise [ Errors::InvalidInt64 ] If the value is invalid.
    #
    # return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_sfixed64(value)
      validate_int64!(value)
      write_fixed64(zig_zag64(value))
    end

    # Write a 32 bit signed integer to the buffer.
    #
    # @example Write the integer to the buffer.
    #   buffer.write_sint32(14)
    #
    # @param [ Integer ] value The integer.
    #
    # @raise [ Errors::InvalidInt32 ] If the value is invalid.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_sint32(value)
      validate_int32!(value)
      write_varint(zig_zag32(value))
    end

    # Write a 64 bit signed integer to the buffer.
    #
    # @example Write the integer to the buffer.
    #   buffer.write_sint64(14)
    #
    # @param [ Integer ] value The integer.
    #
    # @raise [ Errors::InvalidInt64 ] If the value is invalid.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_sint64(value)
      validate_int64!(value)
      write_varint(zig_zag64(value))
    end

    # Write a 32 bit unsigned integer to the buffer.
    #
    # @example Write the integer to the buffer.
    #   buffer.write_uint32(14)
    #
    # @param [ Integer ] value The integer.
    #
    # @raise [ Errors::InvalidUint32 ] If the value is invalid.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_uint32(value)
      validate_uint32!(value)
      write_varint(value)
    end

    # Write a 64 bit unsigned integer to the buffer.
    #
    # @example Write the integer to the buffer.
    #   buffer.write_uint64(14)
    #
    # @param [ Integer ] value The integer.
    #
    # @raise [ Errors::InvalidUint64 ] If the value is invalid.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def write_uint64(value)
      validate_uint64!(value)
      write_varint(value)
    end

    # Write a varint to the buffer.
    #
    # @example Write a varint.
    #   buffer.write_varint(10)
    #
    # @note The shift for negative numbers is explained in the protobuf
    #   documentation: "If you use int32 or int64 as the type for a negative
    #   number, the resulting varint is always ten bytes long – it is,
    #   effectively, treated like a very large unsigned integer."
    #
    # @param [ Integer ] value The integer to write.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding#varints
    #
    # @since 0.0.0
    def write_varint(value)
      append_varint(value)
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
      return self unless value
      append_string(value)
    end
    alias :write_bytes :write_string

    # Exception used for validating integers are in the valid range for the
    # specified type.
    #
    # @since 0.0.0
    class OutsideRange < Exception; end

    private

    # Append a 64bit double to the buffer.
    #
    # @api private
    #
    # @example Write the double to the buffer.
    #   buffer.append_double(1.22)
    #
    # @param [ Float ] value The double value.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def append_double(value)
      bytes << [ value ].pack("E") and self
    end

    # Decode the provided raw string bytes into a double value.
    #
    # @api private
    #
    # @example Decode the double from the string.
    #   buffer.decode_double("\xDD\xCDS\x1Dr\xB3\xF3?")
    #
    # @param [ String ] value The raw string bytes.
    #
    # @return [ Float ] The decoded double value.
    #
    # @since 0.0.0
    def decode_double(value)
      value.unpack("E")[0]
    end

    # Append a fixed size 32 bit integer to the buffer (little endian).
    #
    # @api private
    #
    # @example Append the fixed 32 bit value.
    #   buffer.append_fixed32(1000)
    #
    # @param [ Integer ] value The value to append.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def append_fixed32(value)
      bytes << [ value ].pack("V") and self
    end

    # Append a fixed size 64 bit integer to the buffer (little endian).
    #
    # @api private
    #
    # @example Append the fixed 64 bit value.
    #   buffer.append_fixed64(1000)
    #
    # @param [ Integer ] value The value to append.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def append_fixed64(value)
      bytes << [ value & 0xFFFFFFFF, value >> 32 ].pack("VV") and self
    end

    # Append a 32bit float to the buffer.
    #
    # @api private
    #
    # @example Append the float to the buffer.
    #   buffer.append_float(1.22)
    #
    # @param [ Float ] value The float value.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def append_float(value)
      bytes << [ value ].pack("e") and self
    end

    # Append a string to the buffer via the Protocol Buffer specification.
    #
    # @api private
    #
    # @example Append a string to the buffer.
    #   buffer.append_string("test")
    #
    # @param [ String ] value The string to append.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def append_string(value)
      append_varint(value.length)
      bytes << value and self
    end

    # Append a varint to the buffer.
    #
    # @api private
    #
    # @example Append a varint.
    #   buffer.append_varint(10)
    #
    # @note The shift for negative numbers is explained in the protobuf
    #   documentation: "If you use int32 or int64 as the type for a negative
    #   number, the resulting varint is always ten bytes long – it is,
    #   effectively, treated like a very large unsigned integer."
    #
    # @param [ Integer ] value The integer to append.
    #
    # @return [ Buffer ] The buffer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding#varints
    #
    # @since 0.0.0
    def append_varint(value)
      value += (1 << 64) if value < 0
      while (value > 0x7F) do
        bytes << ((value & 0x7F) | 0x80)
        value >>= 7
      end
      bytes << (value & 0x7F) and self
    end

    # Read the provided number of bytes from the buffer and remove them.
    #
    # @api private
    #
    # @example Read 4 bytes from the buffer.
    #   buffer.read(4)
    #
    # @param [ Integer ] length The number of bytes to read.
    #
    # @return [ String ] The raw bytes.
    #
    # @since 0.0.0
    def read(length)
      bytes.slice!(0, length)
    end

    # Decodes a value that was encoded with "zig-zag" encoding, such as signed
    # integers that aren't varints.
    #
    # @api private
    #
    # @example Un-zig-zag the value.
    #   buffer.un_zig_zag(1241111344224111)
    #
    # @param [ Integer ] The zig-zag encoded value.
    #
    # @return [ Integer ] The decoded value.
    #
    # @since 0.0.0
    def un_zig_zag(value)
      (value >> 1) ^ -(value & 1)
    end

    # Validate that the value is a proper signed 32 bit integer.
    #
    # @api private
    #
    # @example Validate the value.
    #   buffer.validate_int32!(1024)
    #
    # @param [ Integer ] value The integer to validate.
    #
    # @raise [ Errors::InvalidInt32 ] If the value is invalid.
    #
    # @since 0.0.0
    def validate_int32!(value)
      unless value.int32?
        raise OutsideRange.new("#{value} is not a valid 32 bit int.")
      end
    end

    # Validate that the value is a proper signed 64 bit integer.
    #
    # @api private
    #
    # @example Validate the value.
    #   buffer.validate_int64!(1024)
    #
    # @param [ Integer ] value The integer to validate.
    #
    # @raise [ Errors::InvalidInt64 ] If the value is invalid.
    #
    # @since 0.0.0
    def validate_int64!(value)
      unless value.int64?
        raise OutsideRange.new("#{value} is not a valid 64 bit int.")
      end
    end

    # Validate that the value is a proper unsigned 32 bit integer.
    #
    # @api private
    #
    # @example Validate the value.
    #   buffer.validate_uint32!(1024)
    #
    # @param [ Integer ] value The integer to validate.
    #
    # @raise [ Errors::InvalidUint32 ] If the value is invalid.
    #
    # @since 0.0.0
    def validate_uint32!(value)
      unless value.uint32?
        raise OutsideRange.new("#{value} is not a valid 32 bit unsigned int.")
      end
    end

    # Validate that the value is a proper unsigned 64 bit integer.
    #
    # @api private
    #
    # @example Validate the value.
    #   buffer.validate_uint64!(1024)
    #
    # @param [ Integer ] value The integer to validate.
    #
    # @raise [ Errors::InvalidUint64 ] If the value is invalid.
    #
    # @since 0.0.0
    def validate_uint64!(value)
      unless value.uint32?
        raise OutsideRange.new("#{value} is not a valid 64 bit unsigned int.")
      end
    end

    # "Zig-zag" shift a 32 bit value.
    #
    # @api private
    #
    # @example Zig-zag shift the value.
    #   buffer.zig_zag32(234)
    #
    # @param [ Integer ] value The integer to encode.
    #
    # @return [ Integer ] The zig-zaged integer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def zig_zag32(value)
      (value << 1) ^ (value >> 31)
    end

    # "Zig-zag" shift a 64 bit value.
    #
    # @api private
    #
    # @example Zig-zag shift the value.
    #   buffer.zig_zag64(234)
    #
    # @param [ Integer ] value The integer to encode.
    #
    # @return [ Integer ] The zig-zaged integer.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def zig_zag64(value)
      (value << 1) ^ (value >> 63)
    end
  end
end
