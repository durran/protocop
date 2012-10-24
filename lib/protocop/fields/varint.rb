# encoding: utf-8
module Protocop
  module Fields

    # Holds common behaviour for varint frames in a messag.
    #
    # @since 0.0.0
    module Varint
      include Frame

      # Get the key for this field instance.
      #
      # @example Get the key for the field.
      #   field.key
      #
      # @return [ Integer ] The key as a single byte.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def key
        (number << 3) | Wire::VARINT
      end
    end
  end
end
