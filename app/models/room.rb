class Room < ApplicationRecord
  # アソシエーション
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  # 並べ替え
  scope :latest, -> {order(updated_at: :desc)}
end
