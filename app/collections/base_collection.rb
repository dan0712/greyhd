class BaseCollection
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def results
    @results ||= begin
      ensure_filters
      relation
    end
  end

  def meta
    { total: total }
  end

  def total
    results.size
  end

  private

  def filter
    @relation = yield(relation)
  end

  def relation
    fail(NotImplementedError)
  end

  def ensure_filters
    fail(NotImplementedError)
  end
end
