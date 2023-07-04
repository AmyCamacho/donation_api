module Api
  module V1
    class DonationsController < ApplicationController
      def create
        donation = Donation.new(donation_params)

        if donation.save
          render json: donation, status: :created
        else
          render json: { errors: donation.errors }, status: :unprocessable_entity
        end
      end

      private

      def donation_params
        params.require(:donation).permit(:amount, :payment_method, :user_agent, :ip_address, :email, :user_id)
      end
    end
  end
end
