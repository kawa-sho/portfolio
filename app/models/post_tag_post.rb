class PostTagPost < ApplicationRecord
  ## アソシエーション
  belongs_to :post
  belongs_to :tag_post

  ## バリデーション
  validates :post_id, presence: true
  validates :tag_post_id, presence: true
  # 一つの投稿に対して、同じタグをつけられない
  validates_uniqueness_of :post_id, scope: :tag_post_id
end
