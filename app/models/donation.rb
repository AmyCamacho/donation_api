class Donation < ApplicationRecord
  belongs_to :user

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_method, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_create :send_thank_you_email

  def send_thank_you_email
    DonationMailer.thank_you_email(self).deliver_now
  end
end
