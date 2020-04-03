class Loaders::HasManyThroughLoader < GraphQL::Batch::Loader
  def initialize(model, column, options)
    @model = model
    @column = column
    @through = options[:through]
  end

  def perform(relation_ids)
    through_reflections = @model.reflections[@through.to_s]

    records_by_relation_id = through_reflections
      .klass
      .where({ @column => relation_ids })
      .group(@column)
      .select(@column, "ARRAY_AGG(#{through_reflections.foreign_key}) AS record_id")
      .map { |row| [row.public_send(@column), row.record_id] }
      .to_h

    record_ids = records_by_relation_id.values.flatten.uniq

    records_by_id = @model.where(id: record_ids).group_by do |result|
      result.id
    end

    relation_ids.each do |id|
      records = (records_by_relation_id[id] || []).uniq.flat_map do |id|
        records_by_id[id]
      end

      fulfill(id, records)
    end
  end
end
