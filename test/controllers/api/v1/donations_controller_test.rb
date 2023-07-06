require 'test_helper'

class Api::V1::DonationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @donation = donations(:one)
    @user = users(:one)
  end

  test 'should create donation' do
    assert_difference('Donation.count', 1) do
      post api_v1_donations_url, params: {
        donation: {
          amount: 100,
          payment_method: 1,
          user_agent: 'Mozilla/5.0',
          ip_address: '127.0.0.1',
          email: @user.email,
          user_id: @user.id
        }
      }, as: :json
    end

    assert_response :created
  end

  test 'should update donation' do
    patch api_v1_donation_url(@donation),
      params: { donation: { amount: 200, email: 'one@one.org' } },
      headers: { Authorization: JsonWebToken.encode(user_id: @donation.user_id) },
      as: :json

    assert_response :success
  end

  test 'should forbid update donation if user is not the owner' do
    patch api_v1_donation_url(@donation),
      params: { donation: { amount: 200 } },
      headers: { Authorization: JsonWebToken.encode(user_id:users(:two).id) },
      as: :json

    assert_response :forbidden
  end

  test 'should destroy donation' do
    assert_difference('Donation.count', -1) do
      delete api_v1_donation_url(@donation),
        headers: { Authorization: JsonWebToken.encode(user_id: @donation.user_id) },
        as: :json
    end
    assert_response :no_content
  end

  test 'should forbid destroy donation' do
    assert_no_difference('Donation.count') do
      delete api_v1_user_url(@donation),
      headers: { Authorization: JsonWebToken.encode(user_id: users(:two).id) },
      as: :json
    end
    assert_response :forbidden
  end

  test 'should get donations by period' do
    start_date = Date.today - 7.days
    end_date = Date.today
    donations = Donation.where(created_at: start_date..end_date)

    get api_v1_donations_by_period_url(start_date: start_date, end_date: end_date), as: :json

    assert_response :success
    assert_equal donations.to_json, response.body
  end
end
