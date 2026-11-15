module Admin
  class DashboardController < BaseController
    def show
      @counts = {
        published: Article.published.count,
        scheduled: Article.where(published_at: Time.current..).count,
        drafts: Article.where(published_at: nil).count,
        subscribers: Subscriber.count
      }
      @recent = Article.order(updated_at: :desc).includes(:author, :category).limit(10)
    end
  end
end
