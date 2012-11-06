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

      # Encode the field to the buffer with the provided value.
      #
      # @example Encode the field.
      #   field.encode(buffer, "test")
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Object ] value The object value to write.
      #
      # @return [ Buffer ] The buffer that was written to.
      #
      # @see https://developers.google.com/protocol-buffers/docs/encoding#structure
      #
      # @since 0.0.0
      def encode(buffer, value)
        if repeated?
          encode_repeated(buffer, value)
        else
          encode_pair(buffer, value)
        end
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

      # Is this frame packed?
      #
      # @example Is the frame packed?
      #   frame.packed?
      #
      # @return [ true, false ] If the frame is packed.
      #
      # @since 0.0.0
      def packed?
        @packed ||= !!options[:packed]
      end

      # Is this frame repeated?
      #
      # @example Is the frame repeated?
      #   frame.repeated?
      #
      # @return [ true, false ] If the frame is repeated.
      #
      # @since 0.0.0
      def repeated?
        @repeated ||= !!options[:repeated]
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

      private

      # Encode a repeated field, which iterates through the array and encodes
      # each one by one.
      #
      # @api private
      #
      # @example Encode a repeated field.
      #   frame.encode_repeated(buffer, [ 1, 2, 3 ])
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Array ] values The values to write.
      #
      # @return [ Buffer ] The buffer.
      #
      # @since 0.0.0
      def encode_repeated(buffer, values)
        values.each { |value| encode_pair(buffer, value) } and buffer
      end
    end
  end
end
