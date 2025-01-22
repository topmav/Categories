class CreateForms < ActiveRecord::Migration[8.0]
  def change
    create_table :forms do |t|
      t.references :category, foreign_key: true, null: false
      t.json :form_data
      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end
  end
end
