module Admin
  class SubscribersController < BaseController
    def index
      @page = paginate(Subscriber.order(created_at: :desc), per: 50)
      respond_to do |format|
        format.html
        format.csv { send_data Subscriber.order(:created_at).pluck(:email, :created_at).map { it.join(",") }.unshift("email,subscribed_at").join("\n"), filename: "subscribers.csv" }
      end
    end

    def destroy
      Subscriber.find(params[:id]).destroy!
      redirect_to admin_subscribers_path, notice: "Subscriber removed.", status: :see_other
    end
  end
end
