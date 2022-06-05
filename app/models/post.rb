class Post < ApplicationRecord
  # アソシエーション
  belongs_to :customer

  validates :post, length: {minimum: 2 }
end
