module Api
  module V1
    module Admin
      class TeamsController < BaseController
        before_action :authorize_users, only: [:create, :update]

        load_and_authorize_resource except: [:index]
        authorize_resource only: [:index]

        def index
          respond_with current_company.teams.includes(:users, :owner)
        end

        def show
          respond_with @team
        end

        def create
          @team.save!
          respond_with @team
        end

        def update
          @team.update!(team_params)
          respond_with @team
        end

        def destroy
          @team.destroy!
          render nothing: true, status: 204
        end

        private

        def authorize_users
          User.where(id: user_ids).find_each do |user|
            authorize! :manage, user
          end
        end

        def team_params
          params.permit(:name, :owner_id, :description).merge(user_ids: user_ids)
        end

        def user_ids
          @user_ids ||= (params[:users] || []).map { |user| user[:id] }
        end
      end
    end
  end
end
