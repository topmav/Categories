class CreateSellers < ActiveRecord::Migration[7.0]
  def change
    create_table :sellers do |t|
      t.references :category, foreign_key: true, null: false
      t.text :name, null: false
      t.text :website
      t.text :size
      t.text :note
      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end
  end
end