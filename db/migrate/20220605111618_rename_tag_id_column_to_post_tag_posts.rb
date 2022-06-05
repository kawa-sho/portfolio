class RenameTagIdColumnToPostTagPosts < ActiveRecord::Migration[6.1]
  def change
    rename_column :post_tag_posts, :tag_id, :tag_post_id
  end
end
