class AuthorsController < ApplicationController
  allow_unauthenticated_access

  def show
    @author = Author.find_by!(slug: params[:id])
    @page = paginate(@author.articles.published.recent.includes(:author, :category))
  end
end
