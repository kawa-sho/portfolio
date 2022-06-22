require 'rails_helper'

RSpec.describe 'GroupMessageモデルのテスト', type: :model do

  describe 'バリデーションのテスト' do
    subject { group_message.valid? }
    let(:customer) { create(:customer) }
    let(:group) { create(:group, customer_id: customer.id) }
    let!(:group_message) { create(:group_message, customer_id: customer.id, group_id: group.id) }

    context 'messageカラム' do
      it '1文字以上であること: 0文字は×' do
        group_message.message = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it '1文字以上であること: 1文字は〇' do
        group_message.message = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it '100文字以下であること: 100文字は〇' do
        group_message.message = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it '100文字以下であること: 101文字は×' do
        group_message.message = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'groupモデルとの関係' do
      it '1:Nとなっている' do
        expect(GroupMessage.reflect_on_association(:group).macro).to eq :belongs_to
      end
    end
    context 'customerモデルとの関係' do
      it '1:Nとなっている' do
        expect(GroupMessage.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
  end
end