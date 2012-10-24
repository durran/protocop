# encoding: utf-8
module Protocop
  module Fields

    # Holds common behaviour for frames in a message, which are defined in
    # Protocop as fields.
    #
    # @since 0.0.0
    module Frame

      # @attribute [r] number The number of the field in the message.
      attr_reader :number

      # Initialize the new frame in the message.
      #
      # @example Initialize the frame.
      #   Frame.new(1)
      #
      # @param [ Integer ] number The number of the field.
      #
      # @since 0.0.0
      def initialize(number)
        @number = number
      end
    end
  end
end
