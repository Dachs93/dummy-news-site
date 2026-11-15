module Admin
  class ArticlesController < BaseController
    before_action :set_article, only: %i[ edit update destroy ]

    def index
      scope = Article.includes(:author, :category).order(Arel.sql("published_at IS NULL DESC"), published_at: :desc, id: :desc)
      scope = scope.search(params[:q]) if params[:q].present?
      @page = paginate(scope, per: 25)
    end

    def new
      @article = Article.new
      @markdown = ArticleMarkdown.template
    end

    def create
      @article = Article.new
      save_from_markdown(:new, notice: "Article created.")
    end

    def template
      send_data ArticleMarkdown.template, filename: "article_template.md", type: "text/markdown", disposition: "attachment"
    end

    def edit
      @markdown = ArticleMarkdown.from_article(@article)
    end

    def update
      save_from_markdown(:edit, notice: "Article updated.")
    end

    def destroy
      @article.destroy!
      redirect_to admin_articles_path, notice: "Article deleted.", status: :see_other
    end

    private
      def set_article
        @article = Article.find_by!(slug: params[:id])
      end

      def save_from_markdown(template, notice:)
        @markdown = params.require(:markdown)
        if ArticleMarkdown.new(@markdown).assign_to(@article) && @article.save
          redirect_to edit_admin_article_path(@article), notice: notice
        else
          render template, status: :unprocessable_entity
        end
      end
  end
end
