# encoding: utf-8
module Protocop

  # This module is the DSL that is used to define the message structure.
  #
  # @since 0.0.0
  module DSL

    def required(type, name, tag)
      attr_accessor(name)
    end
  end
end
