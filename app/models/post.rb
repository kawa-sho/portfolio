class Post < ApplicationRecord

  # アソシエーション
  belongs_to :customer
  has_many :post_tag_posts,dependent: :destroy
  has_many :tag_posts,through: :post_tag_posts
  has_many :post_comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy

  # バリデーション
  validates :post, length: {minimum: 2, maximum: 200}

  # 並べ替え
  scope :latest, -> {order(created_at: :desc)}

  # 検索機能メソッド
  def self.search(keyword)
    where(["post like?", "%#{keyword}%"])
  end

  # いいねが存在しているかどうかの確認
  def post_favorited_by?(customer)
    post_favorites.exists?(customer_id: customer.id)
  end

  # タグを作成し紐づける
  def save_tag_post(tag_lists)
    # each文でタグリストを回す
    tag_lists.each do |tag_list|
      # TagPostのインスタンスを作る
      new_tag_post = TagPost.find_or_initialize_by(name: tag_list)
      # タグの保存
      if new_tag_post.save
        # 投稿にタグを紐づける
        self.tag_posts << new_tag_post
      end
    end
  end

end
