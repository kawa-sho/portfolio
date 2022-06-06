class PostFavorite < ApplicationRecord

  # アソシエーション
  belongs_to :customer
  belongs_to :post

  #一つの投稿に対して、一人につき一つしかいいねをつけられない。
  validates_uniqueness_of :post_id, scope: :customer_id
end
