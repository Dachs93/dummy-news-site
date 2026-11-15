class SitemapsController < ApplicationController
  allow_unauthenticated_access

  def show
    @articles = Article.published.recent.select(:slug, :updated_at)
    @categories = Category.ordered
    respond_to do |format|
      format.xml
    end
  end
end
