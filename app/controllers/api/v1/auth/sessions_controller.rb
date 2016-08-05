module Api
  module V1
    module Auth
      class SessionsController < ::DeviseTokenAuth::SessionsController
        protected

        def render_create_success
          render json: @resource, serializer: UserSerializer::Full, include: '**'
        end

        def render_create_error_bad_credentials
          render json: { errors: [::Errors::Unauthorized.error] }, status: :unauthorized
        end
      end
    end
  end
end
