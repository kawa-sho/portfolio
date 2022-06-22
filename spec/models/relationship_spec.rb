require 'rails_helper'

RSpec.describe 'Relationshipモデルのテスト', type: :model do

  describe 'バリデーションのテスト' do
    subject { relationship2.valid? }
    let(:customer) { create(:customer) }
    let(:customer2) { create(:customer) }
    let!(:relationship) { create(:relationship, follower_id: customer.id, followed_id: customer2.id) }
    let!(:relationship2) { build(:relationship, follower_id: customer.id, followed_id: customer2.id) }

    context '一つの投稿に一人につき一つしかいいねをつけられない' do
      it '違う会員がいいねをするとき〇' do
        relationship2.follower_id = customer2.id
        relationship2.followed_id = customer.id
        is_expected.to eq true
      end
      it '同じ会員がいいねをするとき×' do
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'followerモデルとの関係' do
      it '1:Nとなっている' do
        expect(Relationship.reflect_on_association(:follower).macro).to eq :belongs_to
      end
    end
    context 'followedモデルとの関係' do
      it '1:Nとなっている' do
        expect(Relationship.reflect_on_association(:followed).macro).to eq :belongs_to
      end
    end
  end
end