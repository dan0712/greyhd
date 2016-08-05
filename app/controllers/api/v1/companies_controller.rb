module Api
  module V1
    class CompaniesController < ApiController
      before_action :require_company!

      def current
        respond_with current_company, serializer: CompanySerializer::Full, include: '**'
      end
    end
  end
end
