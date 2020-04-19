class Loaders::HasManyLoader < GraphQL::Batch::Loader
  def initialize(model, column, joins: nil, sort: nil, limit: nil)
    @model = model
    @column = column
    @joins = joins
    @sort = sort
    @limit = limit
  end

  def perform(relation_ids)
    query = @model
    query = query.joins(@joins) if @joins
    query = query.order(@sort) if @sort

    if @limit
      sub_query = query
                    .where("#{@model.table_name}.#{@column} = tmp_relation_ids")
                    .limit(@limit)

      query = @model
        .select("tmp_lat_join_tab.*")
        .from("UNNEST(ARRAY[#{relation_ids.uniq.join(",")}]) tmp_relation_ids")
        .joins("JOIN LATERAL (#{sub_query.to_sql}) tmp_lat_join_tab ON TRUE")
    else
      query = query.where({ @column => relation_ids.uniq })
    end

    records_by_relation_id = query.group_by do |result|
      result.public_send(@column)
    end

    relation_ids.each do |id|
      fulfill(id, records_by_relation_id[id] || [])
    end
  end
end
