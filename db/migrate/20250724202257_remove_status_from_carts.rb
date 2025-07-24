class RemoveStatusFromCarts < ActiveRecord::Migration[7.0]
  def change
    remove_column :carts, :status, :integer
    remove_column :carts, :completed_at, :datetime if column_exists?(:carts, :completed_at)
  end
end
