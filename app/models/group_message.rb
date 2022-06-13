class GroupMessage < ApplicationRecord

  # アソシエーション
  belongs_to :group
  belongs_to :customer

  # バリデーション
  validates :message,length: { minimum: 1, maximum: 100 }
end
