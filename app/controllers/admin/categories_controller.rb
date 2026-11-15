module Admin
  class CategoriesController < BaseController
    before_action :set_category, only: %i[ edit update destroy ]

    def index
      @categories = Category.ordered.left_joins(:articles).group(:id).select("categories.*, COUNT(articles.id) AS articles_count")
    end

    def new
      @category = Category.new(position: Category.maximum(:position).to_i + 1)
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: "Category created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Category updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @category.destroy
        redirect_to admin_categories_path, notice: "Category deleted.", status: :see_other
      else
        redirect_to admin_categories_path, alert: @category.errors.full_messages.to_sentence, status: :see_other
      end
    end

    private
      def set_category
        @category = Category.find_by!(slug: params[:id])
      end

      def category_params
        params.expect(category: %i[ name slug description position ])
      end
  end
end
