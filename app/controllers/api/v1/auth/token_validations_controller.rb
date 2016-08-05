module Api
  module V1
    module Auth
      class TokenValidationsController < ::DeviseTokenAuth::TokenValidationsController
        protected

        def render_validate_token_success
          render json: @resource, serializer: UserSerializer::Full, include: '**'
        end

        def render_validate_token_error
          render json: { errors: [Errors::Unauthorized.error] }, status: :unauthorized
        end
      end
    end
  end
end
