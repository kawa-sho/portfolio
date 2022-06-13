class Group < ApplicationRecord

  # アソシエーション
  has_many :group_customers
  has_many :customers, through: :group_customers
  has_many :group_messages, dependent: :destroy

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

end
