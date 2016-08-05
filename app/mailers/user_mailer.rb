class UserMailer < ApplicationMailer
  def onboarding_email(invite)
    @invite = invite
    @user = invite.user
    @company = @user.company
    SetUrlOptions.call(@company, ActionMailer::Base.default_url_options)
    mail(
      to: @user.email,
      subject: I18n.t(
        'mailer.onboarding_email.welcome_title',
        company_name: @company.name
      )
    )
  end
end
