module Api
  module V1
    class DonationsController < ApplicationController
      before_action :set_donation, only: %i[update destroy]
      # before_action :check_login, only: %i[create]
      before_action :check_owner, only: %i[update destroy]

      def create
        donation = Donation.new(donation_params)

        if donation.save
          render json: donation, status: :created
        else
          render json: { errors: donation.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @donation.update(donation_params)
          render json: @donation
        else
          render json: { errors: @donation.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @donation.destroy
        head 204
      end

      def by_period
        start_date = params[:start_date]
        end_date = params[:end_date]
        donations = Donation.where(created_at: start_date..end_date)
        render json: donations
      end

      private

      def donation_params
        params.require(:donation).permit(:amount, :payment_method, :user_agent, :ip_address, :email, :user_id)
      end

      def check_owner
        head :forbidden unless @donation.user_id == current_user&.id
      end

      def set_donation
        @donation = Donation.find(params[:id])
      end
    end
  end
end
