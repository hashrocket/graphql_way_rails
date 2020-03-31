class Loaders::HasManyLoader < GraphQL::Batch::Loader
  def initialize(model, column)
    @model = model
    @column = column
  end

  def perform(ids)
    records_by_id = @model.where({ @column => ids.uniq }).group_by do |result|
      result.public_send(@column)
    end

    ids.each do |id|
      fulfill(id, records_by_id[id] || [])
    end
  end
end
