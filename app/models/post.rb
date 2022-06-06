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

  # タグセーブメソッド
  def save_tag(sent_tag_posts)
  # タグが存在していれば、タグの名前を配列として全て取得
    current_tag_posts = self.tag_posts.pluck(:name) unless self.tag_posts.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tag_posts = current_tag_posts - sent_tag_posts
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tag_posts = sent_tag_posts - current_tag_posts

    # 古いタグを消す
    old_tag_posts.each do |old|
      self.tag_posts.delete TagPost.find_by(name: old)
    end

    # 新しいタグを保存
    new_tag_posts.each do |new|
      new_tag_posts = TagPost.find_or_create_by(name: new)
      self.tag_posts << new_tag_posts
   end
  end

  # 必要のないタグの削除
  def self.tag_delete
    TagPost.all.each do |tag|
      if tag.posts.count == 0
        tag.destroy
      end
    end
  end
end
