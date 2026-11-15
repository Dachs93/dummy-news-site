class ArticlesController < ApplicationController
  allow_unauthenticated_access

  def index
    scope = Article.published.recent.includes(:author, :category)
    if params[:tag].present?
      @tag = params[:tag].to_s.downcase
      scope = scope.tagged(@tag)
    end
    @page = paginate(scope)
  end

  def show
    @article = Article.published.includes(:author, :category).find_by!(slug: params[:id])
    fresh_when @article, public: true
  end
end
