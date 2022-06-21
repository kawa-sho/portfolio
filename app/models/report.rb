class Report < ApplicationRecord
  # class_name: "Customer"でCustomerモデルを参照
  belongs_to :reports, class_name: "Customer"
  belongs_to :reported, class_name: "Customer"

  # バリデーション
  validates :message, length: {minimum: 2, maximum: 200}

  # 並べ替え
  scope :latest, -> {order(created_at: :desc)}

  # 通報されたのが多い順
  def self.latest
    group(:reported_id).order('count(reported_id) desc')
  end
end
