class Relationship < ApplicationRecord
  # class_name: "Customer"でCustomerモデルを参照
  belongs_to :follower, class_name: "Customer"
  belongs_to :followed, class_name: "Customer"

  # フォロー複数できないようの処理。
  validates_uniqueness_of :follower_id, scope: :followed_id
end
