class Group < ApplicationRecord

  # アソシエーション
  belongs_to :customer
  has_many :group_customers
  has_many :customers, through: :group_customers
  has_many :group_messages, dependent: :destroy
  has_many :group_tag_groups,dependent: :destroy
  has_many :tag_groups,through: :group_tag_groups
  has_many :group_favorites, dependent: :destroy

  # バリデーション
  validates :name, length: { minimum: 1, maximum: 20 }, uniqueness: true
  validates :introduction, length: { minimum: 1, maximum: 100 }

  # 並べ替え
  scope :latest, -> {order(updated_at: :desc)}

  # active storageでの画像追加
  has_one_attached :group_image

  # group画像のある場合ない場合のメソッド
  def get_group_image
    (group_image.attached?) ? group_image : 'no_image.jpg'
  end

  # 検索機能メソッド
  def self.search(keyword)
    where(["name like?", "%#{keyword}%"])
  end

  # お気に入りが存在しているかどうかの確認
  def group_favorited_by?(customer)
    group_favorites.exists?(customer_id: customer.id)
  end

end
