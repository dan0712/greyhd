class ApiController < ActionController::API
  extend Responders::ControllerMethod

  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions
  include JsonResponder

  respond_to :json
  responders :json

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from CanCan::AccessDenied, with: :forbidden
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

  before_action :set_default_subdomain

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :personal_email, :password) }
  end

  def authenticate_user!
    unauthorized unless current_user
  end

  def current_company
    @current_company ||= env['CURRENT_COMPANY']
  end

  def require_company!
    raise ActiveRecord::RecordNotFound unless current_company
  end

  def verify_current_user_in_current_company!
    raise CanCan::AccessDenied if current_company.id != current_user.company_id
  end

  def set_default_subdomain
    SetUrlOptions.call(current_company, default_url_options)
  end

  def unauthorized
    render json: { errors: [Errors::Unauthorized.error] }, status: :unauthorized
  end

  def not_found(ex)
    render json: { errors: [Errors::NotFound.new(ex.message).error] }, status: :not_found
  end

  def forbidden(ex)
    render json: { errors: [Errors::Forbidden.new(ex.message).error] }, status: :forbidden
  end

  def unprocessable_entity(ex)
    render json: { errors: [Errors::UnprocessableEntity.new(ex.record).error] },
           status: :unprocessable_entity
  end
end
