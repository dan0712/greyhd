module Api
  module V1
    class InvitesController < ApiController
      include DeviseTokenAuth::Concerns::SetUserByToken
      before_action :require_company!
      before_action :set_invite_by_token
      before_action :authenticate_user!
      before_action :verify_current_user_in_current_company!
      before_action :setup_invitation

      def show
        render json: @resource, serializer: UserSerializer::Full
      end

      private

      def setup_invitation
        @client_id = SecureRandom.urlsafe_base64(nil, false)
        @token     = SecureRandom.urlsafe_base64(nil, false)

        @resource.tokens[@client_id] = {
          token: BCrypt::Password.create(@token),
          expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
        }
        @resource.save

        sign_in(:user, @resource, store: false, bypass: false)
      end

      def set_invite_by_token
        @invite = Invite.joins(:user).find_by!(token: params[:token], users: { state: 'invited' })
        @resource = @invite.user
      end
    end
  end
end
