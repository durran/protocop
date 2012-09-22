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
 * Write a variable length integer to the protocol buffer.
 *
 * @example Write a varint.
 *   buffer.write_varint64(10)
 *
 * @note This is a recursive function that will return the buffer when
 *   finished.
 *
 * @param [ Integer ] value The integer to write.
 *
 * @return [ Buffer ] The buffer.
 *
 * @see https://developers.google.com/protocol-buffers/docs/encoding#varints
 *
 * @since 0.0.0
 */
VALUE buffer_write_varint64(VALUE self, VALUE fixnum)
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
  rb_define_method(buffer, "write_string", buffer_write_string, 1);
  rb_define_method(buffer, "write_varint64", buffer_write_varint64, 1);
}
