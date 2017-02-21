class AddStrikeColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :strikes, :minimum_strikes, :integer, default: 1
    add_column :strikes, :maximum_strikes, :integer, default: 1
  end
end
