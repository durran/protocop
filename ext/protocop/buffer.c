#include <ruby.h>
#include <buffer.h>

static VALUE write_string_ext(VALUE self, VALUE string)
{
  VALUE bytes = rb_iv_get(self, "@bytes");
  rb_str_concat(bytes, string);
  return self;
}

void initialize_buffer(VALUE protocop)
{
  VALUE buffer = rb_const_get(protocop, rb_intern("Buffer"));
  rb_define_method(buffer, "write_string", write_string_ext, 1);
}
