class AddRoleToDomains < ActiveRecord::Migration[5.0]
  def change
    add_column :domains, :role, :integer
  end
end
