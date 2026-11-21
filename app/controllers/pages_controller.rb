class PagesController < ApplicationController
  allow_unauthenticated_access

  def about
    @authors = Author.order(:name)
  end

  def contact
  end

  def editorial_policy
  end
end
