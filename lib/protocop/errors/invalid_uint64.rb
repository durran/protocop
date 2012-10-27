# encoding: utf-8
module Protocop
  module Errors

    # This error is raised when a value is provided to the buffer for encoding
    # that is not within the valid range for an unsigned 64 bit integer.
    #
    # @since 0.0.0
    class InvalidUint64 < RuntimeError

      # Initialize the new error.
      #
      # @example Initialize the new error.
      #   InvalidUint64.new(-16)
      #
      # @param [ Integer ] value The invalid value.
      #
      # @since 0.0.0
      def initialize(value)
        super(
          "#{value} is not a valid unsigned 64 bit integer. The value must be between " +
          "#{Integer::MIN_UNSIGNED_64BIT} and #{Integer::MAX_UNSIGNED_64BIT}."
        )
      end
    end
  end
end
