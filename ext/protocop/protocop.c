#include <ruby.h>

/*
* Initialize the protocop extensions.
*
* @since 0.0.0
*/
void Init_protocop()
{
  VALUE protocop = rb_const_get(rb_cObject, rb_intern("Protocop"));
  initialize_buffer(protocop);
}
