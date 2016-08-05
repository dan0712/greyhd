class UsersCollection < BaseCollection
  private

  def relation
    @relation ||= User.all.includes(:profile_image)
  end

  def ensure_filters
    email_filter
    company_filter
    personal_email_filter
    registered_filter
    role_filter
    team_filter
    location_filter
    name_or_email_filter
    exclude_by_ids_filter
  end

  def email_filter
    filter { |relation| relation.where(email: params[:email]) } if params[:email]
  end

  def company_filter
    filter { |relation| relation.where(company_id: params[:company_id]) } if params[:company_id]
  end

  def personal_email_filter
    filter { |relation| relation.where(personal_email: params[:personal_email]) } if params[:personal_email]
  end

  def registered_filter
    filter { |relation| relation.with_state(:registered) } if params[:registered]
  end

  def role_filter
    filter { |relation| relation.where(role: params[:role]) } if params[:role]
  end

  def team_filter
    filter { |relation| relation.where(team_id: params[:team_id]) } if params[:team_id]
  end

  def location_filter
    filter { |relation| relation.where(location_id: params[:location_id]) } if params[:location_id]
  end

  def name_or_email_filter
    filter do |relation|
      pattern = "%#{params[:term].to_s.downcase}%"

      name_query = 'concat_ws(\' \', lower(first_name), lower(last_name)) LIKE ?'
      email_query = 'email LIKE ?'

      relation.where("#{name_query} OR #{email_query}", pattern, pattern)
    end if params[:term]
  end

  def exclude_by_ids_filter
    filter { |relation| relation.where.not(id: params[:exclude_ids]) } if params[:exclude_ids]
  end
end
