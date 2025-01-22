class CreateFormQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :form_questions do |t|
      t.references :category, null: false, foreign_key: true
      t.text :question, null: false
      t.text :question_type
      t.text :reasoning
      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end
  end
end