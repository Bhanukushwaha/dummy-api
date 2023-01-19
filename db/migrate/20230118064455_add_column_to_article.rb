class AddColumnToArticle < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :user_id, :integer
    add_column :comments, :user_id, :integer
    add_column :likes, :user_id, :integer
  end
end
