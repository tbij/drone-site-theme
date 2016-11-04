class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :spreadsheet_key
      t.string :spreadsheet_tab
      t.timestamps
    end
  end
end
