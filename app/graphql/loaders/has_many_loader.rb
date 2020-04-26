class Loaders::HasManyLoader < GraphQL::Batch::Loader
  def initialize(model, column, query_options)
    @model = model
    @column = column
    @query_options = query_options
  end

  def perform(relation_ids)
    query = @model.graphql_query(@query_options)

    if query.limit_value
      sub_query = query.where("#{@model.table_name}.#{@column} = tmp_relation_ids")

      query = @model
        .select("tmp_lat_join_tab.*")
        .from("UNNEST(ARRAY[#{relation_ids.join(",")}]) tmp_relation_ids")
        .joins("JOIN LATERAL (#{sub_query.to_sql}) tmp_lat_join_tab ON TRUE")
    else
      query = query.where({@column => relation_ids})
    end

    records_by_relation_id = query.group_by { |result|
      result.public_send(@column)
    }

    relation_ids.each do |id|
      fulfill(id, records_by_relation_id[id] || [])
    end
  end
end
