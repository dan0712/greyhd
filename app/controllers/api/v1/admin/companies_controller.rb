module Api
  module V1
    module Admin
      class CompaniesController < BaseController
        def index
          collection = CompaniesCollection.new(params)
          respond_with collection.results, each_serializer: CompanySerializer::Short
        end

        def current
          authorize! :read, Company.find(current_company.id)
          respond_with current_company, serializer: CompanySerializer::Full, include: '**'
        end

        def update
          authorize! :update, Company.find(current_company.id)
          company = CompanyForm.new(params.merge(id: current_company.id))
          company.save!
          respond_with company, serializer: CompanySerializer::Full, include: '**'
        end
      end
    end
  end
end
