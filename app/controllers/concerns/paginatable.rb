module Paginatable
  extend ActiveSupport::Concern

  Page = Data.define(:records, :number, :total_pages) do
    def previous? = number > 1
    def next? = number < total_pages
  end

  private
    def paginate(scope, per: 12)
      total_pages = [ (scope.count.to_f / per).ceil, 1 ].max
      number = params[:page].to_i.clamp(1, total_pages)
      Page.new(records: scope.offset((number - 1) * per).limit(per), number:, total_pages:)
    end
end
