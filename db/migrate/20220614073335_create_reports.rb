class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.integer :reports_id
      t.integer :reported_id
      t.string :message

      t.timestamps
    end
  end
end
