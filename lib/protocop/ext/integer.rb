# encoding: utf-8
module Protocop
  module Ext

    # Provides convenience extensions to the core Integer class.
    #
    # @since 0.0.0
    module Integer

      # The maximum signed 32 bit integer value.
      MAX_SIGNED_32BIT = (1 << 31) - 1

      # The maximum unsigned 32 bit integer value.
      MAX_UNSIGNED_32BIT = (1 << 32) - 1

      # The maximum signed 64 bit long value.
      MAX_SIGNED_64BIT = (1 << 63) - 1

      # The maximum unsigned 64 bit long value.
      MAX_UNSIGNED_64BIT = (1 << 64) - 1

      # The minimum signed 32 bit integer value.
      MIN_SIGNED_32BIT = -(1 << 31)

      # The minimum unsigned 32 bit integer value.
      MIN_UNSIGNED_32BIT = 0

      # The miniumum signed 64 bit long value.
      MIN_SIGNED_64BIT = -(1 << 63)

      # The minimum unsigned 64 bit long value.
      MIN_UNSIGNED_64BIT = 0

      # Is this integer value a valid 32 bit signed integer?
      #
      # @example Is the integer 32 bit?
      #   1024.int32?
      #
      # @return [ true, false ] If the integer is 32 bit.
      #
      # @since 0.0.0
      def int32?
        (MIN_SIGNED_32BIT <= self) && (self <= MAX_SIGNED_32BIT)
      end

      # Is this integer value a valid 64 bit signed integer?
      #
      # @example Is the integer 64 bit?
      #   1024.int64?
      #
      # @return [ true, false ] If the integer is 64 bit.
      #
      # @since 0.0.0
      def int64?
        (MIN_SIGNED_64BIT <= self) && (self <= MAX_SIGNED_64BIT)
      end

      # Is this integer value a valid 32 bit unsigned integer?
      #
      # @example Is the integer 32 bit unsigned?
      #   1024.uint32?
      #
      # @return [ true, false ] If the integer is an unsigned 32 bit.
      #
      # @since 0.0.0
      def uint32?
        (MIN_UNSIGNED_32BIT <= self) && (self <= MAX_UNSIGNED_32BIT)
      end

      # Is this integer value a valid 64 bit unsigned integer?
      #
      # @example Is the integer 64 bit unsigned?
      #   1024.uint64?
      #
      # @return [ true, false ] If the integer is an unsigned 64 bit.
      #
      # @since 0.0.0
      def uint64?
        (MIN_UNSIGNED_64BIT <= self) && (self <= MAX_UNSIGNED_64BIT)
      end
    end
  end
end

Integer.__send__(:include, Protocop::Ext::Integer)
