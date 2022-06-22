require 'rails_helper'

RSpec.describe 'TagPostモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { tag_group.valid? }
    let(:tag_group) { create(:tag_group) }

    context 'nameカラム' do
      it '1文字以上であること: 0文字は×' do
        tag_group.name = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it '1文字以上であること: 1文字は〇' do
        tag_group.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it '10文字以下であること: 10文字は〇' do
        tag_group.name = Faker::Lorem.characters(number: 10)
        is_expected.to eq true
      end
      it '10文字以下であること: 11文字は×' do
        tag_group.name = Faker::Lorem.characters(number: 11)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'group_tag_groupsモデルとの関係' do
      it '1:Nとなっている' do
        expect(TagGroup.reflect_on_association(:group_tag_groups).macro).to eq :has_many
      end
    end
    context 'groupsモデルとの関係' do
      it '1:Nとなっている' do
        expect(TagGroup.reflect_on_association(:groups).macro).to eq :has_many
      end
    end
  end

  describe '並べ変えのテスト' do
    let(:customer) { create(:customer) }
    let!(:group) { create(:group, customer_id: customer.id) }
    let!(:group2) { create(:group, customer_id: customer.id) }
    let!(:first_tag_group) { create(:tag_group) }
    let!(:second_tag_group) { create(:tag_group) }
    let!(:third_tag_group) { create(:tag_group) }
    let!(:group_tag_group) { create(:group_tag_group,group_id: group.id, tag_group_id: second_tag_group.id) }
    let!(:group_tag_group2) { create(:group_tag_group,group_id: group2.id, tag_group_id: second_tag_group.id) }
    let!(:group_tag_group3) { create(:group_tag_group,group_id: group.id, tag_group_id: third_tag_group.id) }
    context 'group_count' do
        subject { TagGroup.group_count }
      it do
        is_expected.to eq [second_tag_group, third_tag_group, first_tag_group]
      end
    end
  end

  describe 'メソッドのテスト' do
    let(:customer) { create(:customer) }
    let!(:group) { create(:group, customer_id: customer.id) }
    let!(:tag_group) { create(:tag_group) }
    let!(:tag_group2) { create(:tag_group) }
    let!(:group_tag_group) { create(:group_tag_group,group_id: group.id, tag_group_id: tag_group.id) }

    context 'self.tag_delete' do
      it '紐づいている投稿がない時は削除する' do
        expect(TagGroup.all).to eq [tag_group, tag_group2]
        TagGroup.tag_delete
        expect(TagGroup.all).to eq [tag_group]
      end
    end
  end


end