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
    return buffer_write_uint64(self, INT2FIX(1));
  }
  else {
    return buffer_write_uint64(self, INT2FIX(0));
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
  VALUE bytes = rb_iv_get(self, "@bytes");
  float value = (float) RFLOAT_VALUE(rb_to_float(float_val));
  rb_str_concat(bytes, rb_str_new2((char*) &value));
  return self;
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
  VALUE bytes = rb_iv_get(self, "@bytes");
  if (!NIL_P(string)) {
    rb_str_concat(bytes, string);
  }
  return self;
}

/*
 * Write an unsigned 64 bit integer to the buffer.
 *
 * @example Write a varint.
 *   buffer.write_uint64(10)
 *
 * @param [ Integer ] value The integer to write.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding#varints
 *
 * @since 0.0.0
 */
VALUE buffer_write_uint64(VALUE self, VALUE fixnum)
{
  VALUE bytes = rb_iv_get(self, "@bytes");
  int value = FIX2INT(fixnum);
  while (value > 0x7F) {
    rb_str_concat(bytes, INT2FIX((value & 0x7F) | 0x80));
    value >>=7;
  }
  rb_str_concat(bytes, INT2FIX(value & 0x7F));
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
  rb_define_method(buffer, "write_float", buffer_write_float, 1);
  rb_define_method(buffer, "write_string", buffer_write_string, 1);
  rb_define_method(buffer, "write_uint64", buffer_write_uint64, 1);
}
