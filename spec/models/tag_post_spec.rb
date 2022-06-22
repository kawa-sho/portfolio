require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { tag_post.valid? }
    let(:tag_post) { create(:tag_post) }

    context 'postカラム' do
      it '1文字以上であること: 0文字は×' do
        tag_post.name = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it '1文字以上であること: 1文字は〇' do
        tag_post.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it '10文字以下であること: 10文字は〇' do
        tag_post.name = Faker::Lorem.characters(number: 10)
        is_expected.to eq true
      end
      it '10文字以下であること: 11文字は×' do
        tag_post.name = Faker::Lorem.characters(number: 11)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'post_tag_postsモデルとの関係' do
      it '1:Nとなっている' do
        expect(TagPost.reflect_on_association(:post_tag_posts).macro).to eq :has_many
      end
    end
    context 'postsモデルとの関係' do
      it '1:Nとなっている' do
        expect(TagPost.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
  end

  describe '並べ変えのテスト' do
    let(:customer) { create(:customer) }
    let!(:post) { create(:post, customer_id: customer.id) }
    let!(:post2) { create(:post, customer_id: customer.id) }
    let!(:first_tag_post) { create(:tag_post) }
    let!(:second_tag_post) { create(:tag_post) }
    let!(:third_tag_post) { create(:tag_post) }
    let!(:post_tag_post) { create(:post_tag_post,post_id: post.id, tag_post_id: second_tag_post.id) }
    let!(:post_tag_post2) { create(:post_tag_post,post_id: post2.id, tag_post_id: second_tag_post.id) }
    let!(:post_tag_post3) { create(:post_tag_post,post_id: post.id, tag_post_id: third_tag_post.id) }
    context 'post_count' do
        subject { TagPost.post_count }
      it do
        is_expected.to eq [second_tag_post, third_tag_post, first_tag_post]
      end
    end
  end

  describe 'メソッドのテスト' do
    let(:customer) { create(:customer) }
    let!(:post) { create(:post, customer_id: customer.id) }
    let!(:tag_post) { create(:tag_post) }
    let!(:tag_post2) { create(:tag_post) }
    let!(:post_tag_post) { create(:post_tag_post,post_id: post.id, tag_post_id: tag_post.id) }

    context 'self.tag_delete' do
      it '紐づいている投稿がない時は削除する' do
        expect(TagPost.all).to eq [tag_post, tag_post2]
        TagPost.tag_delete
        expect(TagPost.all).to eq [tag_post]
      end
    end
  end


end