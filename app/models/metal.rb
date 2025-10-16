class Metal < ApplicationRecord
  # Examples: Gold(24k,22k,18k), Silver(925=~22k?), Brass/Alloy for artificial
  validates :name, presence: true
end
