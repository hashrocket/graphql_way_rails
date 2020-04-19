module Types
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument

    def limit_argument(default: 10, min: 0, max: 100)
      prepare = ->(value, _ctx) {
        if value && value.between?(min, max)
          value
        else
          message = "'limit' must be between #{min} and #{max}"
          raise GraphQL::ExecutionError, message
        end
      }

      argument(:limit, Integer, required: false, default_value: default, prepare: prepare)
    end

    def sort_argument(table_name, fields_map)
      fields_map = fields_map.map{ |k, v| [k.to_s, v] }.to_h

      prepare = ->(values, _ctx) {
        sort_map = (values || []).map do |value|
          dir = value[0] == "-" ? :desc : :asc
          value = value[1..-1] if ["+", "-"].include?(value[0])
          if fields_map[value]
            ["#{table_name}.#{fields_map[value]}", dir]
          else
            message = "'sort' must be included in [#{fields_map.keys.join(", ")}] prefixed by a plus or minus sign."
            raise GraphQL::ExecutionError, message
          end
        end.to_h

        sort_map.size > 0 ? sort_map : nil
      }

      argument(:sort, [String], required: false, default_value: [], prepare: prepare)
    end
  end
end
