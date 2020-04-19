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

    def sort_argument(*fields)
      fields = fields.map(&:to_s).map{|field| field.camelize(:lower) }

      argument(
        :sort,
        [String],
        required: false,
        default_value: [],
        prepare: ->(values, _ctx) {
          (values || []).map do |value|
            dir = value[0] == "-" ? :desc : :asc
            value = value[1..-1] if ["+", "-"].include?(value[0])
            if fields.include?(value)
              [value.underscore, dir]
            else
              message = "'sort' must be included in #{fields}"
              raise GraphQL::ExecutionError, message
            end
          end.to_h
        },
      )
    end
  end
end
