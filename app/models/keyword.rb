class Keyword < ApplicationRecord

    # Associations
    belongs_to :category

    validates :keyword, presence: true
end