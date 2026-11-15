class CategoriesController < ApplicationController
  allow_unauthenticated_access

  def show
    @category = Category.find_by!(slug: params[:id])
    @page = paginate(@category.articles.published.recent.includes(:author, :category))
  end
end
