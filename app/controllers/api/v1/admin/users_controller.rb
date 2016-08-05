module Api
  module V1
    module Admin
      class UsersController < BaseController
        load_and_authorize_resource except: [:index, :create, :update]
        authorize_resource only: [:index, :create, :update]

        def index
          collection = UsersCollection.new(collection_params)
          respond_with collection.results, each_serializer: UserSerializer::Short
        end

        def create
          save_respond_with_form
        end

        def show
          respond_with @user, serializer: UserSerializer::Full
        end

        def update
          save_respond_with_form
        end

        private

        def save_respond_with_form
          form = UserForm.new(user_params)
          form.save!
          respond_with form.user, serializer: UserSerializer::Full
        end

        def user_params
          params.merge(company_id: current_company.id)
        end

        def collection_params
          params.merge(company_id: current_company.id)
        end
      end
    end
  end
end
