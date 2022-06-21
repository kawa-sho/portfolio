require 'rails_helper'

RSpec.describe 'Customerモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { customer.valid? }
    let!(:other_customer) { create(:customer) }
    let(:customer) { build(:customer) }

    context 'nameカラム' do
      it '空欄でないこと' do
        customer.name = ''
        is_expected.to eq false
      end
      it '1文字以上であること: 0文字は×' do
        customer.name = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it '1文字以上であること: 1文字は〇' do
        customer.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it '20文字以下であること: 20文字は〇' do
        customer.name = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it '20文字以下であること: 21文字は×' do
        customer.name = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
      it '一意性があること' do
        customer.name = other_customer.name
        is_expected.to eq false
      end
    end

    context 'introductionカラム' do
      it '100文字以下であること: 100文字は〇' do
        customer.introduction = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it '100文字以下であること: 101文字は×' do
        customer.introduction = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'postモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
    context 'post_commentsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:post_comments).macro).to eq :has_many
      end
    end
    context 'post_favoritesモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:post_favorites).macro).to eq :has_many
      end
    end
    context 'groupsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:groups).macro).to eq :has_many
      end
    end
    context 'group_favoritesモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:group_favorites).macro).to eq :has_many
      end
    end
    context 'messagesモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:messages).macro).to eq :has_many
      end
    end
    context 'entriesモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:entries).macro).to eq :has_many
      end
    end
    context 'relationshipsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:relationships).macro).to eq :has_many
      end
    end
    context 'reverse_of_relationshipsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:reverse_of_relationships).macro).to eq :has_many
      end
    end
    context 'followingsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:followings).macro).to eq :has_many
      end
    end
    context 'followersモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:followers).macro).to eq :has_many
      end
    end
    context 'group_customersモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:group_customers).macro).to eq :has_many
      end
    end
    context 'group_messagesモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:group_messages).macro).to eq :has_many
      end
    end
    context 'reportsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:reports).macro).to eq :has_many
      end
    end
    context 'reportedモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:reported).macro).to eq :has_many
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