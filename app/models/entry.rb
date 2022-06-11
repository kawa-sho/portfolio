class Entry < ApplicationRecord
  # アソシエーション
  belongs_to :customer
  belongs_to :room
end
