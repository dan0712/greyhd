module Interactions
  module Invites
    class Create
      attr_reader :invite

      def initialize(invite)
        @invite = invite
      end

      def perform
        ActiveRecord::Base.transaction do
          invite.save!
          invite.user.invite!
          UserMailer.onboarding_email(invite).deliver_now!
        end
      end
    end
  end
end
