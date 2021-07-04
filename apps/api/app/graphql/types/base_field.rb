# frozen_string_literal: true

module Types
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument

    def initialize(*args, null: false, camelize: false, **kwargs, &block)
      # Then, call super _without_ any args, where Ruby will take
      # _all_ the args originally passed to this method and pass it to the super method.
      super
    end
  end
end
