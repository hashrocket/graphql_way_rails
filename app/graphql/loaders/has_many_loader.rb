class Loaders::HasManyLoader < GraphQL::Batch::Loader
  def initialize(model, column, joins: nil, sort: nil)
    @model = model
    @column = column
    @joins = joins
    @sort = sort
  end

  def perform(relation_ids)
    query = @model
    query = query.where({ @column => relation_ids.uniq })
    query = query.joins(@joins) if @joins
    query = query.order(@sort) if @sort

    records_by_relation_id = query.group_by do |result|
      result.public_send(@column)
    end

    relation_ids.each do |id|
      fulfill(id, records_by_relation_id[id] || [])
    end
  end
end
