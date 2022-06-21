require 'rails_helper'

RSpec.describe 'Posrモデルのテスト', type: :model do
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

  end

  describe 'active_storageのチェック' do
    let!(:customer) { create(:customer) }
    it '何も画像が登録されていない場合' do
      expect(customer.get_profile_image).to eq 'no_image.jpg'
    end
      # it '画像が変更された場合' do
      #   customer.profile_image = fixture_file_upload("test.jpg", content_type: 'image/*')
      #   expect(customer.get_profile_image).to eq 'test.jpg'
      # end
  end

  describe 'メソッドのテスト' do
    context 'actibve_for_authentication?' do
    subject { customer.active_for_authentication? }
    let!(:customer) { create(:customer) }
      it '退会していない場合' do
        is_expected.to eq true
      end
      it '退会している場合' do
        customer.is_active = false
        is_expected.to eq false
      end
    end

    context 'self.search(keyword)' do
      let!(:customer) { create(:customer,name: 'テスト') }
      it '検索文字列に部分一致する配列を返すこと' do
        expect(Customer.search('ス')).to include(customer)
      end
      it '検索文字列が一致しない場合、空の配列を返すこと' do
        expect(Customer.search('コ')).to be_empty
      end
      it '検索文字列が空の場合、すべての配列を返すこと' do
        expect(Customer.search('')).to include(customer)
      end
    end

    context 'self.guest' do
    let!(:customer) { Customer.guest }
      it '持ってこれていれば' do
        expect(customer.name).to eq 'guestcustomer'
        expect(customer.email).to eq 'guest@example.com'
      end
    end

    context 'フォロー関連' do
    let!(:fast_customer) { create(:customer) }
    let!(:second_customer) { create(:customer) }
    before do
      fast_customer.follow(second_customer.id)
    end
      it 'follow(customer_id)' do
        expect(Relationship.last.follower_id).to eq fast_customer.id
        expect(Relationship.last.followed_id).to eq second_customer.id
      end
      it 'unfollow(customer_id)' do
        expect(Relationship.last.follower_id).to eq fast_customer.id
        expect(Relationship.last.followed_id).to eq second_customer.id
        fast_customer.unfollow(second_customer.id)
        expect(Relationship.last).to eq nil
      end
      it 'following?(customer)' do
        expect(Relationship.last.follower_id).to eq fast_customer.id
        expect(Relationship.last.followed_id).to eq second_customer.id
        expect(fast_customer.following?(second_customer)).to eq true
        fast_customer.unfollow(second_customer.id)
        expect(Relationship.last).to eq nil
        expect(fast_customer.following?(second_customer)).to eq false
      end
    end

  end


end