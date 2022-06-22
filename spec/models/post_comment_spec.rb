require 'rails_helper'

RSpec.describe 'PostCommentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post_comment.valid? }
    let(:customer) { create(:customer) }
    let(:post) { create(:post, customer_id: customer.id) }
    let!(:post_comment) { build(:post_comment, customer_id: customer.id, post_id: post.id) }

    context 'commentカラム' do
      it '2文字以上であること: 1文字は×' do
        post_comment.comment = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '2文字以上であること: 2文字は〇' do
        post_comment.comment = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
      it '200文字以下であること: 200文字は〇' do
        post_comment.comment = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it '200文字以下であること: 201文字は×' do
        post_comment.comment = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'customerモデルとの関係' do
      it '1:Nとなっている' do
        expect(PostComment.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context 'postモデルとの関係' do
      it '1:Nとなっている' do
        expect(PostComment.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
  end

  describe '並べ変えのテスト' do
    let(:customer) { create(:customer) }
    let(:post) { create(:post,customer_id: customer.id) }
    let!(:first_post_comment) { create(:post_comment, customer_id: customer.id, post_id: post.id, created_at: Time.current - 1.hour) }
    let!(:second_post_comment) { create(:post_comment, customer_id: customer.id, post_id: post.id, created_at: Time.current + 1.hour) }
    let!(:third_post_comment) { create(:post_comment, customer_id: customer.id, post_id: post.id ) }
    context 'latest' do
        subject { PostComment.latest }
      it do
        is_expected.to eq [second_post_comment, third_post_comment, first_post_comment]
      end
    end
  end

end