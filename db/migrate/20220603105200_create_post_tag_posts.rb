class CreatePostTagPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :post_tag_posts do |t|
      t.integer :post_id
      t.integer :tag_post_id

      t.timestamps
    end
  end
end
