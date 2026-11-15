module Admin
  class AuthorsController < BaseController
    before_action :set_author, only: %i[ edit update destroy ]

    def index
      @authors = Author.order(:name).left_joins(:articles).group(:id).select("authors.*, COUNT(articles.id) AS articles_count")
    end

    def new
      @author = Author.new
    end

    def create
      @author = Author.new(author_params)
      if @author.save
        redirect_to admin_authors_path, notice: "Author created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @author.update(author_params)
        redirect_to admin_authors_path, notice: "Author updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @author.destroy
        redirect_to admin_authors_path, notice: "Author deleted.", status: :see_other
      else
        redirect_to admin_authors_path, alert: @author.errors.full_messages.to_sentence, status: :see_other
      end
    end

    private
      def set_author
        @author = Author.find_by!(slug: params[:id])
      end

      def author_params
        params.expect(author: %i[ name slug role bio ])
      end
  end
end
