class SearchController < ApplicationController
  allow_unauthenticated_access

  def index
    @query = params[:q].to_s.strip.first(100)
    @page = paginate(Article.published.recent.search(@query).includes(:author, :category)) if @query.present?
  end
end
