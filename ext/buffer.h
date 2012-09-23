#include <ruby.h>

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
VALUE buffer_equals(VALUE self, VALUE other);

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
VALUE buffer_bytes(VALUE self);

/*
 * Initializes a new Protocop::Buffer.
 *
 * @since 0.0.0
 */
VALUE buffer_initialize(VALUE self);

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
VALUE buffer_write_boolean(VALUE self, VALUE boolean);

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
VALUE buffer_write_bytes(VALUE self, VALUE bytes);

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
VALUE buffer_write_float(VALUE self, VALUE float_val);

VALUE buffer_write_int32(VALUE self, VALUE integer);
VALUE buffer_write_int64(VALUE self, VALUE integer);
VALUE buffer_write_sint32(VALUE self, VALUE integer);
VALUE buffer_write_sint64(VALUE self, VALUE integer);
VALUE buffer_write_uint32(VALUE self, VALUE integer);

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
VALUE buffer_write_string(VALUE self, VALUE string);

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
VALUE buffer_write_uint64(VALUE self, VALUE fixnum);

VALUE buffer_write_varint(VALUE self, VALUE fixnum);

/*
 * Initialize the Protocop::Buffer class.
 *
 * @param [ Module ] protocop The Protocop Ruby module.
 *
 * @since 0.0.0
 */
void initialize_buffer(VALUE protocop);
