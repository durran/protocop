#include <ruby.h>
#include <buffer.h>

/*
 * Gets the wrapped bytes for the buffer.
 *
 * @example Get the wrapped string of bytes.
 *    buffer.bytes
 *
 * @return [ String ] The wrapped bytes.
 *
 * @since 0.0.0
 */
VALUE buffer_bytes(VALUE self)
{
  return rb_iv_get(self, "@bytes");
}

/*
 * Check if this buffer is equal to the other object. Simply checks the
 * bytes against the other's string representation.
 *
 * @example Check buffer equality.
 *   buffer == "testing"
 *
 * @param [ Object ] other The object to check against.
 *
 * @return [ true, false ] If the buffer is equal to the object.
 *
 * @since 0.0.0
 */
VALUE buffer_equals(VALUE self, VALUE other)
{
  VALUE bytes = buffer_bytes(self);
  VALUE other_bytes = buffer_bytes(other);
  return (bytes == other_bytes);
}

/*
 * Initializes a new Protocop::Buffer.
 *
 * @example Initialize the buffer.
 *    Protocop::Buffer.new
 *
 * @since 0.0.0
 */
VALUE buffer_initialize(VALUE self)
{
  VALUE bytes = rb_str_new2("");
  rb_iv_set(self, "@bytes", bytes);
  return self;
}

/*
 * Write a boolean to the buffer.
 *
 * @example Write a true value to the buffer.
 *   buffer.write_boolean(true)
 *
 * @param [ true, false ] value The boolean value.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_boolean(VALUE self, VALUE boolean)
{
  if (RTEST(boolean)) {
    return buffer_write_varint(self, INT2FIX(1));
  }
  else {
    return buffer_write_varint(self, INT2FIX(0));
  }
}

/*
 * Write raw bytes (a ruby string) to the buffer.
 *
 * @example Write bytes to the buffer.
 *   buffer.write_bytes("\x01")
 *
 * @param [ String ] bytes The bytes to write.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_bytes(VALUE self, VALUE bytes)
{
  return buffer_write_string(self, bytes);
}

/*
 * Write a fixed size 64 bit integer to the buffer (little endian).
 *
 * @example Write the fixed 64 bit value.
 *   buffer.write_fixed64(1000)
 *
 * @param [ Integer ] value The value to write.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_fixed64(VALUE self, VALUE fixnum)
{
  VALUE bytes = buffer_bytes(self);
  long value = FIX2LONG(fixnum);

  // @todo: Durran refactor out to method.
  char chars[8] = {
    value & 255,
    (value >> 8) & 255,
    (value >> 16) & 255,
    (value >> 24) & 255,
    (value >> 32) & 255,
    (value >> 40) & 255,
    (value >> 48) & 255,
    (value >> 56) & 255
  };
  rb_str_cat(bytes, chars, 8);
  return self;
}

/*
 * Write a 32bit float to the buffer.
 *
 * @example Write the float to the buffer.
 *   buffer.write_float(1.22)
 *
 * @param [ Float ] value The float value.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_float(VALUE self, VALUE float_val)
{
  VALUE bytes = buffer_bytes(self);
  float value = (float) RFLOAT_VALUE(rb_to_float(float_val));
  rb_str_concat(bytes, rb_str_new2((char*) &value));
  return self;
}

/*
 * Write a 32bit integer to the buffer.
 *
 * @example Write the integer to the buffer.
 *   buffer.write_int32(14)
 *
 * @param [ Integer ] value The integer value.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_int32(VALUE self, VALUE fixnum)
{
  return buffer_write_varint(self, fixnum);
}

/*
 * Write a 64bit integer to the buffer.
 *
 * @example Write the integer to the buffer.
 *   buffer.write_int64(14)
 *
 * @param [ Integer ] value The integer value.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_int64(VALUE self, VALUE fixnum)
{
  return buffer_write_varint(self, fixnum);
}

/*
 * Write a signed fixed size 64 bit integer to the buffer (little endian).
 *
 * @example Write the signed fixed 64 bit value.
 *   buffer.write_sfixed64(1000)
 *
 * @param [ Integer ] value The value to write.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_sfixed64(VALUE self, VALUE fixnum)
{
  VALUE bytes = buffer_bytes(self);
  long value = FIX2LONG(fixnum);
  long converted = (value << 1) ^ (value >> 63);

  // @todo: Durran refactor out to method.
  char chars[8] = {
    converted & 255,
    (converted >> 8) & 255,
    (converted >> 16) & 255,
    (converted >> 24) & 255,
    (converted >> 32) & 255,
    (converted >> 40) & 255,
    (converted >> 48) & 255,
    (converted >> 56) & 255
  };
  rb_str_cat(bytes, chars, 8);
  return self;
}

/*
 * Write a 32bit signed integer to the buffer.
 *
 * @example Write the integer to the buffer.
 *   buffer.write_sint32(14)
 *
 * @param [ Integer ] value The integer value.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_sint32(VALUE self, VALUE fixnum)
{
  return buffer_write_varint(self, fixnum);
}

/*
 * Write a 64bit signed integer to the buffer.
 *
 * @example Write the integer to the buffer.
 *   buffer.write_sint64(14)
 *
 * @param [ Integer ] value The integer value.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_sint64(VALUE self, VALUE fixnum)
{
  return buffer_write_varint(self, fixnum);
}

/*
 * Write a 32bit unsigned integer to the buffer.
 *
 * @example Write the integer to the buffer.
 *   buffer.write_uint32(14)
 *
 * @param [ Integer ] value The integer value.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_uint32(VALUE self, VALUE fixnum)
{
  return buffer_write_varint(self, fixnum);
}

/*
 * Write a 64bit unsigned integer to the buffer.
 *
 * @example Write the integer to the buffer.
 *   buffer.write_uint64(14)
 *
 * @param [ Integer ] value The integer value.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_uint64(VALUE self, VALUE fixnum)
{
  return buffer_write_varint(self, fixnum);
}

/*
 * Write a string to the buffer via the Protocol Buffer specification.
 *
 * @example Write a string to the buffer.
 *   buffer.write_string("test")
 *
 * @param [ String ] value The string to write.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_string(VALUE self, VALUE string)
{
  VALUE bytes = buffer_bytes(self);
  if (!NIL_P(string)) {
    rb_str_concat(bytes, string);
  }
  return self;
}

/*
 * Write a varint to the buffer.
 *
 * @example Write a varint.
 *   buffer.write_varint(10)
 *
 * @param [ Integer ] value The integer to write.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding#varints
 *
 * @since 0.0.0
 */
VALUE buffer_write_varint(VALUE self, VALUE fixnum)
{
  VALUE bytes = buffer_bytes(self);
  int value = FIX2INT(fixnum);
  int size = 0;
  char chars[4];
  while (value > 0x7F) {
    chars[size++] = (value & 0x7F) | 0x80;
    value >>= 7;
  }
  chars[size++] = value & 0x7F;
  rb_str_cat(bytes, chars, size);
  return self;
}

/*
 * Initialize the Protocop::Buffer class.
 *
 * @param [ Module ] protocop The Protocop Ruby module.
 *
 * @since 0.0.0
 */
void initialize_buffer(VALUE protocop)
{
  VALUE buffer = rb_define_class_under(protocop, "Buffer", rb_cObject);
  rb_define_method(buffer, "==", buffer_equals, 1);
  rb_define_method(buffer, "bytes", buffer_bytes, 0);
  rb_define_method(buffer, "initialize", buffer_initialize, 0);
  rb_define_method(buffer, "write_boolean", buffer_write_boolean, 1);
  rb_define_method(buffer, "write_bytes", buffer_write_bytes, 1);
  rb_define_method(buffer, "write_fixed64", buffer_write_fixed64, 1);
  rb_define_method(buffer, "write_float", buffer_write_float, 1);
  rb_define_method(buffer, "write_int32", buffer_write_int32, 1);
  rb_define_method(buffer, "write_int64", buffer_write_int64, 1);
  rb_define_method(buffer, "write_sfixed64", buffer_write_sfixed64, 1);
  rb_define_method(buffer, "write_sint32", buffer_write_sint32, 1);
  rb_define_method(buffer, "write_sint64", buffer_write_sint64, 1);
  rb_define_method(buffer, "write_string", buffer_write_string, 1);
  rb_define_method(buffer, "write_uint32", buffer_write_uint32, 1);
  rb_define_method(buffer, "write_uint64", buffer_write_uint64, 1);
  rb_define_method(buffer, "write_varint", buffer_write_varint, 1);
}
