module Types
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument

    def limit_argument(default: 10, min: 0, max: 100)
      argument(
        :limit,
        Integer,
        required: false,
        default_value: default,
        prepare: ->(value, _ctx) {
          if value && value.between?(min, max)
            value
          else
            message = "'limit' must be between #{min} and #{max}"
            raise GraphQL::ExecutionError, message
          end
        }
      )
    end
  end
end
