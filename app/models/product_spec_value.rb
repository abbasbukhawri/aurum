class ProductSpecValue < ApplicationRecord
  belongs_to :product
  belongs_to :spec_option
end
