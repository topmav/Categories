class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      # Basic information
      t.text :name
      t.text :description
      
      # Lead-related fields
      t.text :qualified_lead_desc
      t.text :unqualified_lead_desc
      t.decimal :suggested_lead_pricing, precision: 10, scale: 2
      t.text :pricing_factors
      
      # Market metrics
      t.integer :monthly_search_volume
      t.decimal :customer_lifetime_value, precision: 10, scale: 2
      
      # Cost metrics
      t.decimal :cpc_low, precision: 10, scale: 2
      t.decimal :cpc_high, precision: 10, scale: 2
      
      # Assessment
      t.text :viability_assessment
      
      # Timestamps
      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end
  end
end