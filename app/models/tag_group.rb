class TagGroup < ApplicationRecord
  # アソシエーション
  has_many :group_tag_groups,dependent: :destroy, foreign_key: 'tag_group_id'
  has_many :groups,through: :group_tag_groups

  # バリデーション
  validates :name, uniqueness: true, length: {minimum: 1, maximum: 10}


  # 並べ替え投稿多い順
  scope :group_count, -> {sort_by {|x| x.groups.count}.reverse}

  # 必要のないタグの削除
  def self.tag_delete
    all.each do |tag|
      if tag.groups.count == 0
        tag.destroy
      end
    end
  end
end
