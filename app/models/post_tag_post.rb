class PostTagPost < ApplicationRecord
  ## アソシエーション
  belongs_to :post
  belongs_to :tag_post
end
