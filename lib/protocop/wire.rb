# encoding: utf-8
module Protocop

  # Defines constant types used in the Protocol Buffer wire protocol.
  #
  # @see https://developers.google.com/protocol-buffers/docs/encoding
  #
  # @since 0.0.0
  module Wire

    # Includes the types: int32, int64, uint32, uint64, sint32, sint64, bool,
    # enum.
    #
    # @return [ Integer ] 0.
    #
    # @since 0.0.0
    VARINT = 0

    # Includes the types: fixed64, sfixed64, double.
    #
    # @return [ Integer ] 1.
    #
    # @since 0.0.0
    BIT64 = 1

    # Includes the types: string, bytes, embedded messages, packed repeated
    # fields.
    #
    # @return [ Integer ] 2.
    #
    # @since 0.0.0
    LENGTH = 2

    # Includes the types: fixed32, sfixed32, float.
    #
    # @return [ Integer ] 5.
    #
    # @since 0.0.0
    BIT32 = 5
  end
end
