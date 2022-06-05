class ChangeDatatypeNameOfTagPosts < ActiveRecord::Migration[6.1]
  def change
    change_column :tag_posts, :name, :string
  end
end
