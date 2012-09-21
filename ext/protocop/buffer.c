#include <ruby.h>
#include <buffer.h>

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
static VALUE buffer_write_string(VALUE self, VALUE string)
{
  VALUE bytes = rb_iv_get(self, "@bytes");
  rb_str_concat(bytes, string);
  return string;
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
  rb_define_method(buffer, "write_string", buffer_write_string, 1);
}
