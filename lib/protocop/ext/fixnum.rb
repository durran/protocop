# encoding: utf-8
module Protocop
  module Ext

    # Provides convenience extensions to the core Fixnum class.
    module Fixnum

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
    end
  end
end

Fixnum.__send__(:include, Protocop::Ext::Fixnum)
