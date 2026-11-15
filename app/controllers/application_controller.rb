class ApplicationController < ActionController::Base
  include Authentication
  include Paginatable

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :nav_categories

  private
    def nav_categories
      @nav_categories ||= Category.ordered.to_a
    end
end
