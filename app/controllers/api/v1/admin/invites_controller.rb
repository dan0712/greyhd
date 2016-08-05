module Api
  module V1
    module Admin
      class InvitesController < BaseController
        load_and_authorize_resource :user
        load_and_authorize_resource :invite, through: :user, shallow: true

        def create
          interaction = Interactions::Invites::Create.new(@invite)
          interaction.perform
          respond_with interaction.invite
        end

        private

        def invite_params
          params.permit(:welcome_note, :additional_information)
        end
      end
    end
  end
end
