require 'rails_helper'

RSpec.describe 'Postモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post.valid? }
    let(:customer) { create(:customer) }
    let!(:post) { build(:post, customer_id: customer.id) }

    context 'postカラム' do
      it '2文字以上であること: 1文字は×' do
        post.post = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '2文字以上であること: 2文字は〇' do
        post.post = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
      it '200文字以下であること: 200文字は〇' do
        post.post = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it '200文字以下であること: 201文字は×' do
        post.post = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'customerモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context 'post_tag_postsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:post_tag_posts).macro).to eq :has_many
      end
    end
    context 'tag_postsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:tag_posts).macro).to eq :has_many
      end
    end
    context 'post_commentsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:post_comments).macro).to eq :has_many
      end
    end
    context 'post_favoritesモデルとの関係' do
      it '1:Nとなっている' do
        expect(Post.reflect_on_association(:post_favorites).macro).to eq :has_many
      end
    end
  end

  describe '並べ変えのテスト' do
    let(:customer) { create(:customer) }
    let!(:first_post) { create(:post, customer_id: customer.id, created_at: Time.current - 1.hour) }
    let!(:second_post) { create(:post, customer_id: customer.id, created_at: Time.current + 1.hour) }
    let!(:third_post) { create(:post, customer_id: customer.id, ) }
    context 'latest' do
        subject { Post.latest }
      it do
        is_expected.to eq [second_post, third_post, first_post]
      end
    end
  end

  describe 'メソッドのテスト' do
    let(:customer) { create(:customer) }

    context 'self.search(keyword)' do
      let!(:post) { create(:post, customer_id: customer.id, post: "テスト") }
      it '検索文字列に部分一致する配列を返すこと' do
        expect(Post.search('ス')).to include(post)
      end
      it '検索文字列が一致しない場合、空の配列を返すこと' do
        expect(Post.search('コ')).to be_empty
      end
      it '検索文字列が空の場合、すべての配列を返すこと' do
        expect(Post.search('')).to include(post)
      end
    end

    context 'post_favorited_by?(customer)' do
    let!(:post) { create(:post, customer_id: customer.id) }
    let(:post_favorite) {PostFavorite.create(customer_id: customer.id, post_id: post.id)}
      it 'post_favoriteがあれば' do
        post_favorite
        expect(post.post_favorited_by?(customer)).to eq true
      end
      it 'post_favoriteがなければ' do
        expect(post.post_favorited_by?(customer)).to eq false
      end
    end
  end


end