#include <ruby.h>
#include <protocop.h>

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
 * Initialize the Protocop::Buffer class.
 *
 * @since 0.0.0
 */
void initialize_buffer();
