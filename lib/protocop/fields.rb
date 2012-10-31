# encoding: utf-8
require "protocop/fields/frame"
require "protocop/fields/bit32"
require "protocop/fields/bit64"
require "protocop/fields/length_delimited"
require "protocop/fields/macros"
require "protocop/fields/varint"
require "protocop/fields/boolean"
require "protocop/fields/bytes"
require "protocop/fields/double"
require "protocop/fields/fixed32"
require "protocop/fields/fixed64"
require "protocop/fields/float"
require "protocop/fields/int32"
require "protocop/fields/int64"
require "protocop/fields/sfixed32"
require "protocop/fields/sfixed64"
require "protocop/fields/sint32"
require "protocop/fields/sint64"
require "protocop/fields/uint32"
require "protocop/fields/uint64"
require "protocop/fields/string"

module Protocop
  module Fields

    # Get all the defined fields for the message.
    #
    # @example Get all defined fields.
    #   message.fields
    #
    # @return [ Hash ] The fields as name/field pairs.
    #
    # @see https://developers.google.com/protocol-buffers/docs/overview
    #
    # @since 0.0.0
    def fields
      self.class.fields
    end
  end
end
