class Report < ApplicationRecord
  # class_name: "Customer"でCustomerモデルを参照
  belongs_to :reports, class_name: "Customer"
  belongs_to :reported, class_name: "Customer"

  # バリデーション
  validates :message, length: {minimum: 2, maximum: 200}
end
