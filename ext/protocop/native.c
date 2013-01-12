#include <ruby.h>
#include <stdint.h>

#if SIZEOF_LONG == 8
  #define I642NUM(v) LONG2NUM(v)
  #define NUM2I64(v) NUM2LONG(v)
#else
  #define I642NUM(v) LL2NUM(v)
  #define NUM2I64(v) NUM2LL(v)
#endif

/**
 * Gets the bytes instance variable from the buffer, which is the raw
 * string of bytes.
 *
 * @example Get the bytes from the buffer.
 *    rb_buffer_bytes(buffer);
 *
 * @param [ Buffer ] self The instance of the buffer object.
 *
 * @return [ String ] The buffer's internal bytes.
 *
 * @since 0.0.0
 */
static VALUE rb_buffer_bytes(VALUE self)
{
  return rb_iv_get(self, "@bytes");
}

/**
 * Append a double to the buffer.
 *
 * @example Append a double to the buffer.
 *    rb_buffer_append_double(buffer, 12.113133);
 *
 * @param [ Buffer ] self The buffer instance.
 * @param [ Float ] value The value to append.
 *
 * @return [ Buffer ] The buffer object.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @since 0.0.0
 */
static VALUE rb_buffer_append_double(VALUE self, VALUE value)
{
  VALUE bytes = rb_buffer_bytes(self);
  double v = NUM2DBL(value);
  rb_str_cat(bytes, (char*) &v, 8);
  return self;
}

/**
 * Append a fixed size 32 bit integer to the buffer (little endian).
 *
 * @example Append the integer.
 *    rb_buffer_append_fixed32(buffer, 1321);
 *
 * @param [ Buffer ] self The buffer instance.
 * @param [ Integer ] value The value to append.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @return [ Buffer ] The buffer object.
 *
 * @since 0.0.0
 */
static VALUE rb_buffer_append_fixed32(VALUE self, VALUE value)
{
  int32_t v = NUM2INT(value);
  char bytes[4] = { v & 255, (v >> 8) & 255, (v >> 16) & 255, (v >> 24) & 255 };
  rb_str_cat(rb_buffer_bytes(self), bytes, 4);
  return self;
}

/**
 * Append a fixed size 64 bit integer to the buffer (little endian).
 *
 * @example Append the integer.
 *    rb_buffer_append_fixed64(buffer, 1321);
 *
 * @param [ Buffer ] self The buffer instance.
 * @param [ Integer ] value The value to append.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @return [ Buffer ] The buffer object.
 *
 * @since 0.0.0
 */
static VALUE rb_buffer_append_fixed64(VALUE self, VALUE value)
{
  int64_t v = NUM2I64(value);
  char bytes[8] = { v & 255, (v >> 8) & 255, (v >> 16) & 255, (v >> 24) & 255,
               (v >> 32) & 255, (v >> 40) & 255, (v >> 48) & 255, (v >> 56) & 255 };
  rb_str_cat(rb_buffer_bytes(self), bytes, 8);
  return self;
}

/**
 * Append a 32bit float to the buffer.
 *
 * @example Append the float.
 *    rb_buffer_append_float(buffer, 12.1113);
 *
 * @param [ Buffer ] self The buffer instance.
 * @param [ Float ] value The value to append.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @return [ Buffer ] The buffer object.
 *
 * @since 0.0.0
 */
static VALUE rb_buffer_append_float(VALUE self, VALUE value)
{
  VALUE bytes = rb_buffer_bytes(self);
  float v = RFLOAT_VALUE(rb_to_float(value));
  rb_str_cat(bytes, (char*) &v, 4);
  return self;
}

/**
 * Append a varint to the buffer.
 *
 * @example Write a varint.
 *    rb_buffer_append_varint(buffer, 144);
 *
 * @note The shift for negative numbers is explained in the protobuf
 *   documentation: "If you use int32 or int64 as the type for a negative
 *   number, the resulting varint is always ten bytes long – it is,
 *   effectively, treated like a very large unsigned integer."
 *
 * @param [ Buffer ] self The buffer instance.
 * @param [ Integer ] value The value to append.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @return [ Buffer ] The buffer object.
 *
 * @since 0.0.0
 */
static VALUE rb_buffer_append_varint(VALUE self, VALUE value)
{
  unsigned long long v = NUM2LL(value);
  int size = 0;
  char chars[10];
  while (v > 0x7F) {
    chars[size++] = (v & 0x7F) | 0x80;
    v >>= 7;
  }
  chars[size++] = v & 0x7F;
  rb_str_cat(rb_buffer_bytes(self), chars, size);
  return self;
}

/**
 * Append a string to the buffer.
 *
 * @example Append the string.
 *    rb_buffer_append_string(buffer, "testing");
 *
 * @param [ Buffer ] self The buffer instance.
 * @param [ String ] value The value to append.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @return [ Buffer ] The buffer object.
 *
 * @since 0.0.0
 */
static VALUE rb_buffer_append_string(VALUE self, VALUE value)
{
  int length = RSTRING_LEN(value);
  rb_buffer_append_varint(self, INT2NUM(length));
  rb_str_cat(rb_buffer_bytes(self), RSTRING_PTR(value), length);
  return self;
}

/**
 * Decodes the provided raw bytes as a string into a double value.
 *
 * @example Decode the double.
 *    rb_buffer_decode_double(buffer, "\xDD\xCDS\x1Dr\xB3\xF3?");
 *
 * @param [ Buffer ] self The buffer instance.
 * @param [ String ] value The raw bytes for the double.
 *
 * @return [ Float ] The double value.
 *
 * @since 0.0.0
 */
static VALUE rb_buffer_decode_double(VALUE self, VALUE value)
{
  char * bytes;
  double v;
  StringValue(value);
  bytes = RSTRING_PTR(value);
  memcpy(&v, bytes, RSTRING_LEN(value));
  return DBL2NUM(v);
}

/**
 * Decodes the provided raw bytes as a string into a 32 bit integer value.
 *
 * @example Decode the fixed 32 bit int.
 *    rb_buffer_decode_fixed32(buffer, "\xD0\a\x00\x00");
 *
 * @param [ Buffer ] self The buffer instance.
 * @param [ String ] value The raw bytes for the int.
 *
 * @return [ Integer ] The integer value.
 *
 * @since 0.0.0
 */
static VALUE rb_buffer_decode_fixed32(VALUE self, VALUE value)
{
  const uint8_t *v;
  StringValue(value);
  v = (const uint8_t*) RSTRING_PTR(value);
  return INT2NUM(v[0] + (v[1] << 8) + (v[2] << 16) + (v[3] << 24));
}

/**
 * Decodes the provided raw bytes as a string into a float value.
 *
 * @example Decode the float.
 *    rb_buffer_decode_float(buffer, "\xDD\xCDS\x1Dr\xB3\xF3?");
 *
 * @param [ Buffer ] self The buffer instance.
 * @param [ String ] value The raw bytes for the float.
 *
 * @return [ Float ] The float value.
 *
 * @since 0.0.0
 */
static VALUE rb_buffer_decode_float(VALUE self, VALUE value)
{
  char * bytes;
  float v;
  StringValue(value);
  bytes = RSTRING_PTR(value);
  memcpy(&v, bytes, RSTRING_LEN(value));
  return DBL2NUM((double) v);
}

/**
 * Zig-zag encode a 32bit integer.
 *
 * @example Encode the integer.
 *    rb_buffer_zig_zag32(buffer, 10);
 *
 * @param [ Buffer ] self The buffer instance.
 * @param [ Integer ] value The value to encode.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @return [ Integer ] The encoded integer.
 *
 * @since 0.0.0
 */
static VALUE rb_buffer_zig_zag32(VALUE self, VALUE value)
{
  int64_t v = NUM2I64(value);
  return I642NUM((v << 1) ^ (v >> 31));
}

/**
 * Zig-zag encode a 64bit integer.
 *
 * @example Encode the integer.
 *    rb_buffer_zig_zag64(buffer, 10);
 *
 * @param [ Buffer ] self The buffer instance.
 * @param [ Integer ] value The value to encode.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding
 *
 * @return [ Integer ] The encoded integer.
 *
 * @since 0.0.0
 */
static VALUE rb_buffer_zig_zag64(VALUE self, VALUE value)
{
  int64_t v = NUM2I64(value);
  return I642NUM((v << 1) ^ (v >> 63));
}

/**
 * Initializes the Protocop native c extensions.
 *
 * @since 0.0.0
 */
void Init_native()
{
  VALUE protocop = rb_const_get(rb_cObject, rb_intern("Protocop"));
  VALUE buffer = rb_const_get(protocop, rb_intern("Buffer"));

  rb_remove_method(buffer, "append_double");
  rb_define_private_method(buffer, "append_double", rb_buffer_append_double, 1);
  rb_remove_method(buffer, "append_fixed32");
  rb_define_private_method(buffer, "append_fixed32", rb_buffer_append_fixed32, 1);
  rb_remove_method(buffer, "append_fixed64");
  rb_define_private_method(buffer, "append_fixed64", rb_buffer_append_fixed64, 1);
  rb_remove_method(buffer, "append_float");
  rb_define_private_method(buffer, "append_float", rb_buffer_append_float, 1);
  rb_remove_method(buffer, "append_string");
  rb_define_private_method(buffer, "append_string", rb_buffer_append_string, 1);
  rb_remove_method(buffer, "append_varint");
  rb_define_private_method(buffer, "append_varint", rb_buffer_append_varint, 1);
  rb_remove_method(buffer, "decode_double");
  rb_define_private_method(buffer, "decode_double", rb_buffer_decode_double, 1);
  rb_remove_method(buffer, "decode_fixed32");
  rb_define_private_method(buffer, "decode_fixed32", rb_buffer_decode_fixed32, 1);
  rb_remove_method(buffer, "decode_float");
  rb_define_private_method(buffer, "decode_float", rb_buffer_decode_float, 1);
  rb_remove_method(buffer, "zig_zag32");
  rb_define_private_method(buffer, "zig_zag32", rb_buffer_zig_zag32, 1);
  rb_remove_method(buffer, "zig_zag64");
  rb_define_private_method(buffer, "zig_zag64", rb_buffer_zig_zag64, 1);
}
