class RenameCustomerIdColumnToTagPosts < ActiveRecord::Migration[6.1]
  def change
    rename_column :tag_posts, :customer_id, :name
  end
end
