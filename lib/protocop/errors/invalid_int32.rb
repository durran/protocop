# encoding: utf-8
module Protocop
  module Errors

    # This error is raised when a value is provided to the buffer for encoding
    # that is not within the valid range for a 32 bit integer.
    #
    # @since 0.0.0
    class InvalidInt32 < RuntimeError

      # Initialize the new error.
      #
      # @example Initialize the new error.
      #   InvalidInt32.new(2 ** 64)
      #
      # @param [ Integer ] value The invalid value.
      #
      # @since 0.0.0
      def initialize(value)
        super(
          "#{value} is not a valid 32 bit integer. The value must be between " +
          "#{Integer::MIN_SIGNED_32BIT} and #{Integer::MAX_SIGNED_32BIT}."
        )
      end
    end
  end
end
