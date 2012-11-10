# encoding: utf-8
module Protocop
  module Fields

    # Holds common behaviour for length based frames in a message.
    #
    # @since 0.0.0
    module LengthDelimited
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
        (number << 3) | Wire::LENGTH
      end

      # Is the field packable?
      #
      # @example Is the field packable?
      #   frame.packable?
      #
      # @return [ false ] Always false for length delimited fields.
      #
      # @since 0.0.0
      def packable?
        false
      end
    end
  end
end
