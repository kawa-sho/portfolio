class CreateGroupMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :group_messages do |t|
      t.integer :customer_id
      t.integer :group_id
      t.text :message

      t.timestamps
    end
  end
end
