module Api
  module V1
    module Admin
      module EmailPreview
        class UserMailerController < BaseController
          load_and_authorize_resource :user, parent: false

          def invite
            @invite = Invite.new(invite_params)
            @company = @user.company
            @company.owner = @company.owner

            render 'user_mailer/onboarding_email'
          end

          private

          def invite_params
            params.permit(:welcome_note, :additional_information)
          end
        end
      end
    end
  end
end
