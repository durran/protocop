# encoding: utf-8
module Protocop
  module Fields

    # Holds common behaviour for frames in a message, which are defined in
    # Protocop as fields.
    #
    # @since 0.0.0
    module Frame

      # @attribute [r] type The type of field.
      # @attribute [r] name The name of the field in the message.
      # @attribute [r] number The number of the field in the message.
      # @attribute [r] options The field options.
      attr_reader :type, :name, :number, :options

      # Get the default for the field, or nil if none was defined.
      #
      # @example Get the default value.
      #   frame.default
      #
      # @return [ Object ] The default value.
      #
      # @since 0.0.0
      def default
        options[:default]
      end

      # Initialize the new frame in the message.
      #
      # @example Initialize the frame.
      #   Frame.new(1)
      #
      # @param [ Module, Symbol ] type The field's type.
      # @param [ Symbol ] name The name of the field.
      # @param [ Integer ] number The number of the field.
      # @param [ Hash ] options The field options.
      #
      # @option options [ Integer ] :default The default enumeration value.
      #
      # @since 0.0.0
      def initialize(type, name, number, options = {})
        @type, @name, @number, @options = type, name, number, options
      end

      # Is this frame required?
      #
      # @example Is the frame required?
      #   frame.required?
      #
      # @return [ true, false ] If the frame is required.
      #
      # @since 0.0.0
      def required?
        @required ||= !!options[:required]
      end
    end
  end
end
