class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :summary
      t.text :body, null: false
      t.references :category, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true
      t.datetime :published_at
      t.boolean :featured, null: false, default: false
      t.string :tags, null: false, default: ""
      t.integer :reading_minutes, null: false, default: 1

      t.timestamps
    end
    add_index :articles, :slug, unique: true
    add_index :articles, :published_at
    add_index :articles, [ :featured, :published_at ]
  end
end
