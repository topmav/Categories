class Seller < ApplicationRecord

    # Associations
    belongs_to :category

    validates :name, presence: true
end