class Gemstone < ApplicationRecord
  enum :kind, { natural: 0, lab_created: 1, artificial: 2 }, prefix: true
  validates :name, presence: true
end
