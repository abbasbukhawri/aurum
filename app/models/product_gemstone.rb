class ProductGemstone < ApplicationRecord
  belongs_to :product
  belongs_to :gemstone
end
