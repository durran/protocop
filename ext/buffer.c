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
 * Appends a 32 bit value to the end of a Ruby string.
 *
 * @api private
 *
 * @since 0.0.0
 */
VALUE buffer_concat_fixed32(VALUE self, VALUE bytes, int value)
{
  char chars[4] = {
    value & 255,
    (value >> 8) & 255,
    (value >> 16) & 255,
    (value >> 24) & 255
  };
  rb_str_cat(bytes, chars, 4);
  return self;
}

/*
 * Appends a 64 bit value to the end of a Ruby string.
 *
 * @api private
 *
 * @since 0.0.0
 */
VALUE buffer_concat_fixed64(VALUE self, VALUE bytes, long long value)
{
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

void buffer_validate_int32(VALUE self, VALUE value)
{
  rb_funcall(self, rb_intern("validate_int32!"), 1, value);
}

void buffer_validate_int64(VALUE self, VALUE value)
{
  rb_funcall(self, rb_intern("validate_int64!"), 1, value);
}

void buffer_validate_uint32(VALUE self, VALUE value)
{
  rb_funcall(self, rb_intern("validate_uint32!"), 1, value);
}

void buffer_validate_uint64(VALUE self, VALUE value)
{
  rb_funcall(self, rb_intern("validate_uint64!"), 1, value);
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
* Write a 64bit double to the buffer.
*
* @example Write the double to the buffer.
*   buffer.write_double(1.22)
*
* @param [ Float ] value The double value.
*
* @return [ Buffer ] The buffer.
*
* @see https://developers.google.com/protocol-buffers/docs/encoding
*
* @since 0.0.0
*/
VALUE buffer_write_double(VALUE self, VALUE float_val)
{
  VALUE bytes = buffer_bytes(self);
  double value = (double) NUM2DBL(float_val);
  rb_str_cat(bytes, (char*) &value, 8);
  return self;
}

/*
 * Write a fixed size 32 bit integer to the buffer (little endian).
 *
 * @example Write the fixed 32 bit value.
 *   buffer.write_fixed32(1000)
 *
 * @param [ Integer ] value The value to write.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_fixed32(VALUE self, VALUE number)
{
  buffer_validate_int32(self, number);
  VALUE bytes = buffer_bytes(self);
  int value = NUM2INT(number);
  return buffer_concat_fixed32(self, bytes, value);
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
VALUE buffer_write_fixed64(VALUE self, VALUE number)
{
  buffer_validate_int64(self, number);
  VALUE bytes = buffer_bytes(self);
  long long value = NUM2LONG(number);
  return buffer_concat_fixed64(self, bytes, value);
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
  rb_str_cat(bytes, (char*) &value, 4);
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
VALUE buffer_write_int32(VALUE self, VALUE number)
{
  buffer_validate_int32(self, number);
  return buffer_write_varint(self, number);
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
VALUE buffer_write_int64(VALUE self, VALUE number)
{
  buffer_validate_int64(self, number);
  return buffer_write_varint(self, number);
}

/*
 * Write a signed fixed size 32 bit integer to the buffer (little endian).
 *
 * @example Write the signed fixed 32 bit value.
 *   buffer.write_sfixed32(1000)
 *
 * @param [ Integer ] value The value to write.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
VALUE buffer_write_sfixed32(VALUE self, VALUE number)
{
  buffer_validate_int32(self, number);
  VALUE bytes = buffer_bytes(self);
  int value = NUM2INT(number);
  int converted = (value << 1) ^ (value >> 31);
  return buffer_concat_fixed32(self, bytes, converted);
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
VALUE buffer_write_sfixed64(VALUE self, VALUE number)
{
  buffer_validate_int64(self, number);
  VALUE bytes = buffer_bytes(self);
  long long value = NUM2LONG(number);
  long long converted = (value << 1) ^ (value >> 63);
  return buffer_concat_fixed64(self, bytes, converted);
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
VALUE buffer_write_sint32(VALUE self, VALUE number)
{
  buffer_validate_int32(self, number);
  int value = NUM2INT(number);
  int converted = (value << 1) ^ (value >> 31);
  return buffer_write_varint(self, INT2FIX(converted));
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
VALUE buffer_write_sint64(VALUE self, VALUE number)
{
  buffer_validate_int64(self, number);
  long value = NUM2LONG(number);
  long converted = (value << 1) ^ (value >> 63);
  return buffer_write_varint(self, LONG2NUM(converted));
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
VALUE buffer_write_uint32(VALUE self, VALUE number)
{
  buffer_validate_uint32(self, number);
  return buffer_write_varint(self, number);
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
VALUE buffer_write_uint64(VALUE self, VALUE number)
{
  buffer_validate_uint64(self, number);
  return buffer_write_varint(self, number);
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
  if (!NIL_P(string)) {
    VALUE bytes = buffer_bytes(self);
    rb_str_cat(bytes, RSTRING_PTR(string), RSTRING_LEN(string));
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
VALUE buffer_write_varint(VALUE self, VALUE number)
{
  VALUE bytes = buffer_bytes(self);
  int value = NUM2INT(number);
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
  VALUE buffer = rb_const_get(protocop, rb_intern("Buffer"));

  rb_define_method(buffer, "write_boolean", buffer_write_boolean, 1);
  rb_define_method(buffer, "write_bytes", buffer_write_bytes, 1);
  rb_define_method(buffer, "write_double", buffer_write_double, 1);
  rb_define_method(buffer, "write_fixed32", buffer_write_fixed32, 1);
  rb_define_method(buffer, "write_fixed64", buffer_write_fixed64, 1);
  rb_define_method(buffer, "write_float", buffer_write_float, 1);
  rb_define_method(buffer, "write_int32", buffer_write_int32, 1);
  rb_define_method(buffer, "write_int64", buffer_write_int64, 1);
  rb_define_method(buffer, "write_sfixed32", buffer_write_sfixed32, 1);
  rb_define_method(buffer, "write_sfixed64", buffer_write_sfixed64, 1);
  rb_define_method(buffer, "write_sint32", buffer_write_sint32, 1);
  rb_define_method(buffer, "write_sint64", buffer_write_sint64, 1);
  rb_define_method(buffer, "write_string", buffer_write_string, 1);
  rb_define_method(buffer, "write_uint32", buffer_write_uint32, 1);
  rb_define_method(buffer, "write_uint64", buffer_write_uint64, 1);
  rb_define_method(buffer, "write_varint", buffer_write_varint, 1);
}
