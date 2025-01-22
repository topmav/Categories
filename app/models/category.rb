class Category < ApplicationRecord

    # Associations
    has_many :sellers, dependent: :destroy
    has_many :keywords, dependent: :destroy
    has_many :form_questions, dependent: :destroy
    has_one :form

    validates :name, presence: true
  end