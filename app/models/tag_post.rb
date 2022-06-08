class TagPost < ApplicationRecord
  # アソシエーション
  has_many :post_tag_posts,dependent: :destroy, foreign_key: 'tag_post_id'
  has_many :posts,through: :post_tag_posts

  # バリデーション
  validates :name, uniqueness: true, length: {minimum: 1, maximum: 10}


  # 並べ替え投稿多い順
  scope :post_count, -> {sort_by {|x| x.posts.count}.reverse}

end
