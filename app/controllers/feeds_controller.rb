class FeedsController < ApplicationController
  allow_unauthenticated_access

  def show
    @articles = Article.published.recent.includes(:author, :category).limit(30)
    respond_to do |format|
      format.atom
    end
  end
end
