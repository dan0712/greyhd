class CompaniesCollection < BaseCollection
  private

  def relation
    @relation ||= Company.all
  end

  def ensure_filters
    email_filter
  end

  def email_filter
    if params[:email]
      filter { |relation| relation.where('LOWER(email) = LOWER(?)', params[:email]) }
    end
  end
end
