# encoding: utf-8
module Protocop
  module Errors

    # This error is raised when a value is provided to the buffer for encoding
    # that is not within the valid range for an unsigned 32 bit integer.
    #
    # @since 0.0.0
    class InvalidUint32 < RuntimeError

      # Initialize the new error.
      #
      # @example Initialize the new error.
      #   InvalidUint32.new(-16)
      #
      # @param [ Integer ] value The invalid value.
      #
      # @since 0.0.0
      def initialize(value)
        super(
          "#{value} is not a valid unsigned 32 bit integer. The value must be between " +
          "#{Integer::MIN_UNSIGNED_32BIT} and #{Integer::MAX_UNSIGNED_32BIT}."
        )
      end
    end
  end
end
