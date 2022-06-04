class CreateTagPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_posts do |t|
      t.integer :customer_id

      t.timestamps
    end
  end
end
