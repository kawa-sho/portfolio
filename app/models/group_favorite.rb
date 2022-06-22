class GroupFavorite < ApplicationRecord

  # アソシエーション
  belongs_to :customer
  belongs_to :group

  # 一つのグループに対して、一人につき一つしかお気に入りをつけられない。
  validates_uniqueness_of :group_id, scope: :customer_id

  # お気に入りが作られた順
  scope :latest, -> {order(created_at: :desc)}
end
