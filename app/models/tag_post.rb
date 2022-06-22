class TagPost < ApplicationRecord
  # アソシエーション
  has_many :post_tag_posts,dependent: :destroy, foreign_key: 'tag_post_id'
  has_many :posts,through: :post_tag_posts

  # バリデーション
  validates :name, uniqueness: true, length: {minimum: 1, maximum: 10}


  # 並べ替え投稿多い順
  scope :post_count, -> {sort_by {|x| x.posts.count}.reverse}

  # 必要のないタグの削除
  def self.tag_delete
    all.each do |tag|
      if tag.posts.count == 0
        tag.destroy
      end
    end
  end
end
