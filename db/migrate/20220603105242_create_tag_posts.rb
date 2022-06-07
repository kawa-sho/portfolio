class CreateTagPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_posts do |t|
      t.string :name
      t.timestamps
    end
  end
end
