class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    published = Article.published.recent.includes(:author, :category)
    @lead = published.featured.first || published.first
    @top_stories = published.where.not(id: @lead&.id).featured.limit(4).to_a
    @top_stories += published.where.not(id: [ @lead&.id, *@top_stories.map(&:id) ]).limit(4 - @top_stories.size) if @top_stories.size < 4
    excluded = [ @lead&.id, *@top_stories.map(&:id) ].compact
    @latest = published.where.not(id: excluded).limit(9)
    @popular_tags = popular_tags
  end

  private
    def popular_tags
      Article.published.recent.limit(100).pluck(:tags)
        .flat_map { it.split(",") }.tally.sort_by { |tag, count| [ -count, tag ] }.first(16).map(&:first)
    end
end
