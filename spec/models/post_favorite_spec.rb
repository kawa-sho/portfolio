require 'rails_helper'

RSpec.describe 'PostFavoriteモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post_favorite2.valid? }
    let(:customer) { create(:customer) }
    let(:customer2) { create(:customer) }
    let(:post) { create(:post, customer_id: customer.id) }
    let!(:post_favorite) { create(:post_favorite, customer_id: customer.id, post_id: post.id) }
    let!(:post_favorite2) { build(:post_favorite, customer_id: customer.id, post_id: post.id) }

    context '一つの投稿に一人につき一つしかいいねをつけられない' do
      it '違う会員がいいねをするとき〇' do
        post_favorite2.customer_id = customer2.id
        is_expected.to eq true
      end
      it '同じ会員がいいねをするとき×' do
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'customerモデルとの関係' do
      it '1:Nとなっている' do
        expect(PostFavorite.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context 'postモデルとの関係' do
      it '1:Nとなっている' do
        expect(PostFavorite.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
  end

  describe '並べ変えのテスト' do
    let(:customer) { create(:customer) }
    let(:customer2) { create(:customer) }
    let(:customer3) { create(:customer) }
    let(:post) { create(:post,customer_id: customer.id) }
    let!(:first_post_favorite) { create(:post_favorite, customer_id: customer.id, post_id: post.id, created_at: Time.current - 1.hour) }
    let!(:second_post_favorite) { create(:post_favorite, customer_id: customer2.id, post_id: post.id, created_at: Time.current + 1.hour) }
    let!(:third_post_favorite) { create(:post_favorite, customer_id: customer3.id, post_id: post.id ) }
    context 'latest' do
        subject { PostFavorite.latest }
      it do
        is_expected.to eq [second_post_favorite, third_post_favorite, first_post_favorite]
      end
    end
  end

end