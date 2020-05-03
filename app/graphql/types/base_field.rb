module Types
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument

    def limit_argument(default: 10, min: 1, max: 100)
      prepare = ->(value, _ctx) {
        if value&.between?(min, max)
          value
        else
          message = "'limit' must be between #{min} and #{max}"
          raise GraphQL::ExecutionError, message
        end
      }

      argument(:limit, Integer, required: false, default_value: default, prepare: prepare)
    end

    def page_argument(default: 1, min: 1)
      prepare = ->(value, _ctx) {
        if value && value >= min
          value
        else
          message = "'page' must be greater or equals than #{min}"
          raise GraphQL::ExecutionError, message
        end
      }

      argument(:page, Integer, required: false, default_value: default, prepare: prepare)
    end
  end
end
