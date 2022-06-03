class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :customer_id
      t.text :post

      t.timestamps
    end
  end
end
