# encoding: utf-8
module Protocop

  # Module to be extended by any message that can be decoded from an inbound
  # stream into a message object.
  #
  # @since 0.0.0
  module Decodable

    # Decode the provided stream into the extending module's class, as per the
    # Protocol Buffer specification.
    #
    # @param
    #
    # @return [ Class ] The type of class that extended the Decodable.
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def decode(inbound)
    end
  end
end
