class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # ニックネームのバリデーションを一番上にするためにここに記述
  validates :name, length: { minimum: 1, maximum: 20 }, uniqueness: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy

  # DM機能
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # グループ関連
  has_many :group_customers

  # active storageでの画像追加
  has_one_attached :profile_image


  # バリデーション
  validates :introduction, length: { maximum: 100 }

  # プロフィール画像のある場合ない場合のメソッド
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  # 退会してたらログインできないメソッド
  def active_for_authentication?
    super && (is_active == true)
  end

  # 検索機能メソッド
  def self.search(keyword)
    where(["name like?", "%#{keyword}%"])
  end

  # ゲストログイン用メソッド
  def self.guest
    #存在するかしないかを判断し名前とメールアドレスとパスワードの作成
    find_or_create_by!(name: 'guestcustomer' ,email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.email = "guest@example.com"
    end
  end

  ## フォロー関連
  # フォローしたときの処理
  def follow(customer_id)
    relationships.create(followed_id: customer_id)
  end
  # フォローを外すときの処理
  def unfollow(customer_id)
    relationships.find_by(followed_id: customer_id).destroy
  end
  # フォローしているか判定
  def following?(customer)
    followings.include?(customer)
  end
end
