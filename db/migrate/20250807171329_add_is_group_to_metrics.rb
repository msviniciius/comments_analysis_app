class AddIsGroupToMetrics < ActiveRecord::Migration[5.2]
  def change
    add_column :metrics, :is_group, :boolean
  end
end
