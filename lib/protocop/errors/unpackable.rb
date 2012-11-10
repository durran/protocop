# encoding: utf-8
module Protocop
  module Errors

    # This error is raised when trying to define a field as packed that is
    # length-delimited and cannot be so.
    #
    # @since 0.0.0
    class Unpackable < RuntimeError

      # Initialize the error.
      #
      # @example Initialize the error.
      #   Unpackable.new(:string)
      #
      # @param [ Symbol ] type The attempted type.
      #
      # @since 0.0.0
      def initialize(type)
        super(
          "#{type.inspect} is not a valid field to be packed. " +
          "Only non length-delimited fields are valid."
        )
      end
    end
  end
end
