class FormAnswer < ApplicationRecord

    # Associations
    belongs_to :form_question

    validates :answer, presence: true
end