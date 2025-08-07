class CreateMetrics < ActiveRecord::Migration[5.2]
  def change
    create_table :metrics do |t|
      t.references :user, foreign_key: true
      t.float :avg
      t.float :median
      t.float :std_dev
      t.integer :count

      t.timestamps
    end
  end
end
