class AddImageToArticles < ActiveRecord::Migration[8.1]
  def change
    add_column :articles, :image, :string
    add_column :articles, :image_alt, :string
    add_column :articles, :image_caption, :string
  end
end
