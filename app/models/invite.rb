class Invite < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true

  before_validation :ensure_token

  private

  def ensure_token
    unless self.token
      raw, enc = Devise.token_generator.generate(self.class, :token)
      self.token = enc
    end
  end
end
