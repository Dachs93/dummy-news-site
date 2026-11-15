class SubscribersController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 5, within: 10.minutes, only: :create,
    with: -> { redirect_back_or_to root_path, alert: "Too many attempts. Please try again later." }

  def create
    subscriber = Subscriber.find_or_initialize_by(email: params.require(:subscriber)[:email].to_s.strip.downcase)
    if subscriber.persisted? || subscriber.save
      redirect_back_or_to root_path, notice: "Thanks! You're on the list for the weekly digest."
    else
      redirect_back_or_to root_path, alert: "Please enter a valid email address."
    end
  end
end
