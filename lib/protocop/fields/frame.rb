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
        validate_packing(type, options)
      end

      # Is the field packable? This is all field types except length-delimited.
      #
      # @example Is the field packable?
      #   frame.packable?
      #
      # @return [ true ] Always true for non length delimited fields.
      #
      # @since 0.0.0
      def packable?
        true
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

      # Get the key that is used for packed fields.
      #
      # @example Get the packed field key.
      #   frame.packed_key
      #
      # @return [ Integer ] The length delimited key.
      #
      # @since 0.0.0
      def packed_key
        (number << 3) | Wire::LENGTH
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

      # Raised when attempting to define a packed repeated field that is not
      # length delimited.
      #
      # @since 0.0.0
      class Unpackable < Exception; end

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
        if packed?
          encode_packed(buffer, values)
        else
          encode_pairs(buffer, values)
        end
      end

      # Encode the key/value pairs of repeated fields.
      #
      # @api private
      #
      # @example Encode the pairs.
      #   frame.encode_pairs(buffer, [ 1, 2, 3 ])
      #
      # @param [ Buffer ] buffer The buffer to encode to.
      # @param [ Array ] values The values to write.
      #
      # @return [ Buffer ] The buffer.
      #
      # @since 0.0.0
      def encode_pairs(buffer, values)
        values.each { |value| encode_pair(buffer, value) }
        return buffer
      end

      # Validate if the field can be packed.
      #
      # @api private
      #
      # @example Validate the packing options.
      #   frame.validate_packing(:string, packed: true)
      #
      # @param [ Synbol ] type The field type.
      # @param [ Hash ] options The field options.
      #
      # @raise [ Errors::Unpackable ] If the packing is invalid.
      #
      # @since 0.0.0
      def validate_packing(type, options = {})
        if packed? && !packable?
          raise Unpackable.new("#{type} is not a packable field type.")
        end
      end

      # Execute the provided block with packing, yielding to each value in the
      # array.
      #
      # @api private
      #
      # @example Encode with packing.
      #   frame.with_packing(buffer, [ 1, 2, 3 ]) do |value|
      #     buffer.write_int32(value)
      #   end
      #
      # @param [ Buffer ] buffer The buffer to write to.
      # @param [ Array ] values The values to write.
      #
      # @return [ Buffer ] The buffer.
      #
      # @since 0.0.0
      def with_packing(buffer, values)
        unless values.empty?
          packed = Buffer.new
          values.each { |value| yield(value, packed) }
          buffer.write_varint(packed_key)
          buffer.write_bytes(packed.bytes)
        else
          buffer
        end
      end
    end
  end
end
