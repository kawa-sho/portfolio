require 'rails_helper'

RSpec.describe 'GroupFavoriteモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { group_favorite2.valid? }
    let(:customer) { create(:customer) }
    let(:customer2) { create(:customer) }
    let(:group) { create(:group, customer_id: customer.id) }
    let!(:group_favorite) { create(:group_favorite, customer_id: customer.id, group_id: group.id) }
    let!(:group_favorite2) { build(:group_favorite, customer_id: customer.id, group_id: group.id) }

    context '一つのグループに一人につき一つしかお気に入りをつけられない' do
      it '違う会員がお気に入りをするとき〇' do
        group_favorite2.customer_id = customer2.id
        is_expected.to eq true
      end
      it '同じ会員がお気に入りをするとき×' do
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'customerモデルとの関係' do
      it '1:Nとなっている' do
        expect(GroupFavorite.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context 'postモデルとの関係' do
      it '1:Nとなっている' do
        expect(GroupFavorite.reflect_on_association(:group).macro).to eq :belongs_to
      end
    end
  end

  describe '並べ変えのテスト' do
    let(:customer) { create(:customer) }
    let(:customer2) { create(:customer) }
    let(:customer3) { create(:customer) }
    let(:group) { create(:group,customer_id: customer.id) }
    let!(:first_group_favorite) { create(:group_favorite, customer_id: customer.id, group_id: group.id, created_at: Time.current - 1.hour) }
    let!(:second_group_favorite) { create(:group_favorite, customer_id: customer2.id, group_id: group.id, created_at: Time.current + 1.hour) }
    let!(:third_group_favorite) { create(:group_favorite, customer_id: customer3.id, group_id: group.id ) }
    context 'latest' do
        subject { GroupFavorite.latest }
      it do
        is_expected.to eq [second_group_favorite, third_group_favorite, first_group_favorite]
      end
    end
  end

end