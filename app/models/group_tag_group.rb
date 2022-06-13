class GroupTagGroup < ApplicationRecord
  ## アソシエーション
  belongs_to :group
  belongs_to :tag_group
end
