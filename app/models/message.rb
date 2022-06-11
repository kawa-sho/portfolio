class Message < ApplicationRecord
  # アソシエーション
  belongs_to :customer
  belongs_to :room

  # バリデーション
  validates :message,length: { minimum: 1, maximum: 100 }

  # 並べ替え
  scope :latest, -> {order(created_at: :desc)}
end
