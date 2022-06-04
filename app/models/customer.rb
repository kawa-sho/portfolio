class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_many :posts, dependent: :destroy


  # active storageでの画像追加
  has_one_attached :profile_image


  # バリデーション
  validates :name, length: { minimum: 1, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  # プロフィール画像のある場合ない場合のメソッド
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  # 退会してたらログインできないメソッド
  def active_for_authentication?
    super && (is_active == true)
  end


  # ゲストログイン用メソッド
  def self.guest
    #存在するかしないかを判断し名前とメールアドレスとパスワードの作成
    find_or_create_by!(name: 'guestcustomer' ,email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.email = "guest@example.com"
    end
  end
end
