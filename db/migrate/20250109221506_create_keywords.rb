class CreateKeywords < ActiveRecord::Migration[7.1]
  def change
    create_table :keywords do |t|
      t.references :category, foreign_key: true, null: false
      t.text :keyword, null: false
      t.integer :monthly_search_volume
      
      
      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end
    
    add_index :keywords, :keyword
  end
end