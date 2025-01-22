class FormQuestion < ApplicationRecord

    # Associations
    belongs_to :category
    has_many :form_answers

    validates :question, presence: true
    validates :question_type, presence: true
    validates :reasoning, presence: true
end