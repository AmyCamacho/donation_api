require 'test_helper'

class Api::V1::DonationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should create donation" do
    assert_difference('Donation.count', 1) do
      post api_v1_donations_url, params: {
        donation: {
          amount: 100,
          payment_method: 1,
          user_agent: "Mozilla/5.0",
          ip_address: "127.0.0.1",
          email: @user.email,
          user_id: @user.id
        }
      }, as: :json
    end

    assert_response :created
  end
end
