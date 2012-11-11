#include <ruby.h>
#include <buffer.h>

static VALUE buffer_bytes(VALUE self)
{
  return rb_iv_get(self, "@bytes");
}

static VALUE buffer_concat_fixed32(VALUE self, VALUE bytes, int value)
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

static VALUE buffer_concat_fixed64(VALUE self, VALUE bytes, long long value)
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

static void buffer_validate_int32(VALUE self, VALUE value)
{
  rb_funcall(self, rb_intern("validate_int32!"), 1, value);
}

static void buffer_validate_int64(VALUE self, VALUE value)
{
  rb_funcall(self, rb_intern("validate_int64!"), 1, value);
}

static void buffer_validate_uint32(VALUE self, VALUE value)
{
  rb_funcall(self, rb_intern("validate_uint32!"), 1, value);
}

static void buffer_validate_uint64(VALUE self, VALUE value)
{
  rb_funcall(self, rb_intern("validate_uint64!"), 1, value);
}

static int buffer_convert_int(VALUE self, VALUE number)
{
  buffer_validate_int32(self, number);
  return NUM2INT(number);
}

static long long buffer_convert_long(VALUE self, VALUE number)
{
  buffer_validate_int64(self, number);
  return NUM2LONG(number);
}

static VALUE buffer_write_varint(VALUE self, VALUE number)
{
  VALUE bytes = buffer_bytes(self);
  unsigned long long value = NUM2LL(number);
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

static VALUE buffer_write_string(VALUE self, VALUE string)
{
  if (!NIL_P(string)) {
    VALUE bytes = buffer_bytes(self);
    rb_str_cat(bytes, RSTRING_PTR(string), RSTRING_LEN(string));
  }
  return self;
}

static VALUE buffer_write_boolean(VALUE self, VALUE boolean)
{
  if (RTEST(boolean)) {
    return buffer_write_varint(self, INT2FIX(1));
  }
  else {
    return buffer_write_varint(self, INT2FIX(0));
  }
}

static VALUE buffer_write_bytes(VALUE self, VALUE bytes)
{
  return buffer_write_string(self, bytes);
}

static VALUE buffer_write_double(VALUE self, VALUE float_val)
{
  VALUE bytes = buffer_bytes(self);
  double value = (double) NUM2DBL(float_val);
  rb_str_cat(bytes, (char*) &value, 8);
  return self;
}

static VALUE buffer_write_fixed32(VALUE self, VALUE number)
{
  int value = buffer_convert_int(self, number);
  VALUE bytes = buffer_bytes(self);
  return buffer_concat_fixed32(self, bytes, value);
}

static VALUE buffer_write_fixed64(VALUE self, VALUE number)
{
  long long value = buffer_convert_long(self, number);
  VALUE bytes = buffer_bytes(self);
  return buffer_concat_fixed64(self, bytes, value);
}

static VALUE buffer_write_float(VALUE self, VALUE float_val)
{
  VALUE bytes = buffer_bytes(self);
  float value = (float) RFLOAT_VALUE(rb_to_float(float_val));
  rb_str_cat(bytes, (char*) &value, 4);
  return self;
}

static VALUE buffer_write_int32(VALUE self, VALUE number)
{
  buffer_validate_int32(self, number);
  return buffer_write_varint(self, number);
}

static VALUE buffer_write_int64(VALUE self, VALUE number)
{
  buffer_validate_int64(self, number);
  return buffer_write_varint(self, number);
}

static VALUE buffer_write_sfixed32(VALUE self, VALUE number)
{
  int value = buffer_convert_int(self, number);
  int converted = (value << 1) ^ (value >> 31);
  VALUE bytes = buffer_bytes(self);
  return buffer_concat_fixed32(self, bytes, converted);
}

static VALUE buffer_write_sfixed64(VALUE self, VALUE number)
{
  long long value = buffer_convert_long(self, number);
  long long converted = (value << 1) ^ (value >> 63);
  VALUE bytes = buffer_bytes(self);
  return buffer_concat_fixed64(self, bytes, converted);
}

static VALUE buffer_write_sint32(VALUE self, VALUE number)
{
  int value = buffer_convert_int(self, number);
  int converted = (value << 1) ^ (value >> 31);
  return buffer_write_varint(self, INT2FIX(converted));
}

static VALUE buffer_write_sint64(VALUE self, VALUE number)
{
  long value = buffer_convert_long(self, number);
  long converted = (value << 1) ^ (value >> 63);
  return buffer_write_varint(self, LONG2NUM(converted));
}

static VALUE buffer_write_uint32(VALUE self, VALUE number)
{
  buffer_validate_uint32(self, number);
  return buffer_write_varint(self, number);
}

static VALUE buffer_write_uint64(VALUE self, VALUE number)
{
  buffer_validate_uint64(self, number);
  return buffer_write_varint(self, number);
}

void initialize_buffer(VALUE protocop)
{
  VALUE buffer = rb_const_get(protocop, rb_intern("Buffer"));

  rb_remove_method(buffer, "write_boolean");
  rb_define_method(buffer, "write_boolean", buffer_write_boolean, 1);

  rb_remove_method(buffer, "write_bytes");
  rb_define_method(buffer, "write_bytes", buffer_write_bytes, 1);

  rb_remove_method(buffer, "write_double");
  rb_define_method(buffer, "write_double", buffer_write_double, 1);

  rb_remove_method(buffer, "write_fixed32");
  rb_define_method(buffer, "write_fixed32", buffer_write_fixed32, 1);

  rb_remove_method(buffer, "write_fixed64");
  rb_define_method(buffer, "write_fixed64", buffer_write_fixed64, 1);

  rb_remove_method(buffer, "write_float");
  rb_define_method(buffer, "write_float", buffer_write_float, 1);

  rb_remove_method(buffer, "write_int32");
  rb_define_method(buffer, "write_int32", buffer_write_int32, 1);

  rb_remove_method(buffer, "write_int64");
  rb_define_method(buffer, "write_int64", buffer_write_int64, 1);

  rb_remove_method(buffer, "write_sfixed32");
  rb_define_method(buffer, "write_sfixed32", buffer_write_sfixed32, 1);

  rb_remove_method(buffer, "write_sfixed64");
  rb_define_method(buffer, "write_sfixed64", buffer_write_sfixed64, 1);

  rb_remove_method(buffer, "write_sint32");
  rb_define_method(buffer, "write_sint32", buffer_write_sint32, 1);

  rb_remove_method(buffer, "write_sint64");
  rb_define_method(buffer, "write_sint64", buffer_write_sint64, 1);

  rb_remove_method(buffer, "write_string");
  rb_define_method(buffer, "write_string", buffer_write_string, 1);

  rb_remove_method(buffer, "write_uint32");
  rb_define_method(buffer, "write_uint32", buffer_write_uint32, 1);

  rb_remove_method(buffer, "write_uint64");
  rb_define_method(buffer, "write_uint64", buffer_write_uint64, 1);

  rb_remove_method(buffer, "write_varint");
  rb_define_method(buffer, "write_varint", buffer_write_varint, 1);
}
