require 'test_helper'

class DonationTest < ActiveSupport::TestCase
  test 'should be valid with valid attributes' do
    donation = Donation.new(
      amount: 100.0,
      payment_method: 1,
      email: 'test@example.com',
      user: users(:one) # Assumes you have a fixture or factory for users
    )
    assert donation.valid?
  end

  test 'should be invalid without an amount' do
    donation = Donation.new(
      payment_method: 1,
      email: 'test@example.com',
      user: users(:one)
    )
    assert_not donation.valid?
    assert_includes donation.errors[:amount], "can't be blank"
  end

  test 'should be invalid without a payment method' do
    donation = Donation.new(
      amount: 100.0,
      email: 'test@example.com',
      user: users(:one)
    )
    assert_not donation.valid?
    assert_includes donation.errors[:payment_method], "can't be blank"
  end

  test 'should be invalid without an email' do
    donation = Donation.new(
      amount: 100.0,
      payment_method: 1,
      user: users(:one)
    )
    assert_not donation.valid?
    assert_includes donation.errors[:email], "can't be blank"
  end

  test 'should be invalid with an invalid email format' do
    donation = Donation.new(
      amount: 100.0,
      payment_method: 1,
      email: 'invalid_email',
      user: users(:one)
    )
    assert_not donation.valid?
    assert_includes donation.errors[:email], 'is invalid'
  end

  test 'should send thank you email after creation' do
    donation = Donation.create(
      amount: 100.0,
      payment_method: 1,
      email: 'test@example.com',
      user: users(:one)
    )

    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal 'Thank you for your donation!', ActionMailer::Base.deliveries.last.subject
    assert_equal 'test@example.com', ActionMailer::Base.deliveries.last.to[0]
  end
end
