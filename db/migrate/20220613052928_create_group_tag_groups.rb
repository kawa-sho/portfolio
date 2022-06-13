class CreateGroupTagGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :group_tag_groups do |t|
      t.integer :group_id
      t.integer :tag_group_id

      t.timestamps
    end
  end
end
