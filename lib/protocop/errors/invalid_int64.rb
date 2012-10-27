# encoding: utf-8
module Protocop
  module Errors

    # This error is raised when a value is provided to the buffer for encoding
    # that is not within the valid range for a 64 bit integer.
    #
    # @since 0.0.0
    class InvalidInt64 < RuntimeError

      # Initialize the new error.
      #
      # @example Initialize the new error.
      #   InvalidInt64.new(2 ** 80)
      #
      # @param [ Integer ] value The invalid value.
      #
      # @since 0.0.0
      def initialize(value)
        super(
          "#{value} is not a valid 64 bit integer. The value must be between " +
          "#{Integer::MIN_SIGNED_64BIT} and #{Integer::MAX_SIGNED_64BIT}."
        )
      end
    end
  end
end
