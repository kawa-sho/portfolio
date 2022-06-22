require 'rails_helper'

RSpec.describe 'GroupTagGroupモデルのテスト', type: :model do

  describe 'アソシエーションのテスト' do
    context 'groupモデルとの関係' do
      it '1:Nとなっている' do
        expect(GroupTagGroup.reflect_on_association(:group).macro).to eq :belongs_to
      end
    end
    context 'tag_groupモデルとの関係' do
      it '1:Nとなっている' do
        expect(GroupTagGroup.reflect_on_association(:tag_group).macro).to eq :belongs_to
      end
    end
  end

end