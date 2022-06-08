class PostTagPost < ApplicationRecord
  ## アソシエーション
  belongs_to :post
  belongs_to :tag_post

  ## バリデーション
  #validates :post_id, presence: true
  #validates :tag_post_id, presence: true
end
