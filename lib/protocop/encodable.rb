# encoding: utf-8
module Protocop

  # Module to be included in any message that can be encoded into an outbound
  # stream.
  #
  # @since 0.0.0
  module Encodable

    # Encode the including module into a stream that conforms to the Protocol
    # Buffer specification.
    #
    # @return
    #
    # @see https://developers.google.com/protocol-buffers/docs/encoding
    #
    # @since 0.0.0
    def encode
    end
  end
end
