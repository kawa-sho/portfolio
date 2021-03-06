class PostComment < ApplicationRecord

  # アソシエーション
  belongs_to :customer
  belongs_to :post

  # バリデーション
  validates :comment, length: { minimum: 2, maximum: 200}

  # コメントが作られた順
  scope :latest, -> {order(created_at: :desc)}
end
