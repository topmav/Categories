class CreateFormAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :form_answers do |t|
      t.references :form_question, null: false, foreign_key: true
      t.text :answer, null: false
      t.timestamptz :created_at, null: false
      t.timestamptz :updated_at, null: false
    end
  end
end