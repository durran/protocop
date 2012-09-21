#include <ruby.h>
#include <buffer.h>

/*
 * Initialize the protocop extensions, which is a c version of the
 * Buffer class.
 *
 * @since 0.0.0
 */
void Init_protocop()
{
  VALUE protocop = rb_define_module("Protocop");
  initialize_buffer(protocop);
}
