class CompanyMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    unless env['PATH_INFO'][%r{/assets/}]
      env['CURRENT_COMPANY'] = find_company(env)
    end

    app.call(env)
  end

  private

  attr_reader :app

  def find_company(env)
    company_by_domain(env) || company_by_subdomain(env)
  end

  def company_by_domain(env)
    Company.find_by(domain: env['SERVER_NAME'])
  end

  def company_by_subdomain(env)
    subdomain = find_subdomain(env)
    return if subdomain.blank?

    Company.find_by(subdomain: subdomain)
  end

  def find_subdomain(env)
    return unless env['SERVER_NAME'].match(/\.#{ENV['DEFAULT_HOST']}$/)

    env['SERVER_NAME'].remove(/\.#{ENV['DEFAULT_HOST']}$/)
  end
end
