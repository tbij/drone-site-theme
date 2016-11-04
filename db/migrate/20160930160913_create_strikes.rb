class CreateStrikes < ActiveRecord::Migration[5.0]
  def change
    create_table :strikes do |t|
      t.references :country
      t.references :location
      t.string :strike_id
      t.date   :date
      t.integer :minimum_people_killed
      t.integer :maximum_people_killed
      t.integer :minimum_civilians_killed
      t.integer :maximum_civilians_killed
      t.integer :minimum_children_killed
      t.integer :maximum_children_killed
      t.integer :minimum_people_injured
      t.integer :maximum_people_injured
      t.integer :index
      t.timestamps
    end
  end
end

