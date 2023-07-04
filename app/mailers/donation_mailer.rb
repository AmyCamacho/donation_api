class DonationMailer < ApplicationMailer
  def thank_you_email(donation)
    @donation = donation
    mail(to: @donation.email, subject: 'Thank you for your donation!')
  end
end
