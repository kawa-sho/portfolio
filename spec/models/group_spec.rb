require 'rails_helper'

RSpec.describe 'Groupモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { group.valid? }
    let(:customer) { create(:customer) }
    let!(:other_group) { create(:group,customer_id: customer.id) }
    let(:group) { build(:group,customer_id: customer.id) }

    context 'nameカラム' do
      it '1文字以上であること: 0文字は×' do
        group.name = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it '1文字以上であること: 1文字は〇' do
        group.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it '20文字以下であること: 20文字は〇' do
        group.name = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it '20文字以下であること: 21文字は×' do
        group.name = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
      it '一意性があること' do
        group.name = other_group.name
        is_expected.to eq false
      end
    end

    context 'introductionカラム' do
      it '1文字以上であること: 0文字は×' do
        group.introduction = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it '1文字以上であること: 1文字は〇' do
        group.introduction = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it '100文字以下であること: 100文字は〇' do
        group.introduction = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it '100文字以下であること: 101文字は×' do
        group.introduction = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'customerモデルとの関係' do
      it '1:Nとなっている' do
        expect(Group.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context 'group_customersモデルとの関係' do
      it '1:Nとなっている' do
        expect(Group.reflect_on_association(:group_customers).macro).to eq :has_many
      end
    end
    context 'customersモデルとの関係' do
      it '1:Nとなっている' do
        expect(Group.reflect_on_association(:customers).macro).to eq :has_many
      end
    end
    context 'group_messagesモデルとの関係' do
      it '1:Nとなっている' do
        expect(Group.reflect_on_association(:group_messages).macro).to eq :has_many
      end
    end
    context 'group_tag_groupsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Group.reflect_on_association(:group_tag_groups).macro).to eq :has_many
      end
    end
    context 'tag_groupsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Group.reflect_on_association(:tag_groups).macro).to eq :has_many
      end
    end
    context 'group_favoritesモデルとの関係' do
      it '1:Nとなっている' do
        expect(Group.reflect_on_association(:group_favorites).macro).to eq :has_many
      end
    end
  end

  describe '並べ変えのテスト' do
    let(:customer) { create(:customer) }
    let!(:first_group) { create(:group,customer_id: customer.id, updated_at: Time.current - 1.hour) }
    let!(:second_group) { create(:group,customer_id: customer.id, updated_at: Time.current + 1.hour) }
    let!(:third_group) { create(:group,customer_id: customer.id) }
    context 'latest' do
        subject { Group.latest }
      it do
        is_expected.to eq [second_group, third_group, first_group]
      end
    end
  end

  describe 'active_storageのチェック' do
    let(:customer) { create(:customer) }
    let(:group) { create(:group,customer_id: customer.id) }
    it '何も画像が登録されていない場合' do
      expect(group.get_group_image).to eq 'no_image.jpg'
    end
      it '画像が変更された場合' do
        group.group_image = fixture_file_upload("test.jpg", content_type: 'image/*')
        expect(group.get_group_image.filename.to_s).to eq 'test.jpg'
      end
  end

  describe 'メソッドのテスト' do
    let(:customer) { create(:customer) }

    context 'self.search(keyword)' do
      let!(:group) { create(:group, customer_id: customer.id, name: "テスト") }
      it '検索文字列に部分一致する配列を返すこと' do
        expect(Group.search('ス')).to include(group)
      end
      it '検索文字列が一致しない場合、空の配列を返すこと' do
        expect(Group.search('コ')).to be_empty
      end
      it '検索文字列が空の場合、すべての配列を返すこと' do
        expect(Group.search('')).to include(group)
      end
    end

    context 'group_favorited_by?(customer)' do
    let!(:group) { create(:group, customer_id: customer.id) }
    let(:group_favorite) {GroupFavorite.create(customer_id: customer.id, group_id: group.id)}
      it 'group_favoriteがあれば' do
        group_favorite
        expect(group.group_favorited_by?(customer)).to eq true
      end
      it 'group_favoriteがなければ' do
        expect(group.group_favorited_by?(customer)).to eq false
      end
    end

    context 'save_tag_group(tag_lists)' do
      let!(:group) { create(:group, customer_id: customer.id) }
      it 'タグを紐づけて保存できる' do
        tag_lists = ['test','test2','test3']
        group.save_tag_group(tag_lists)
        expect(group.tag_groups.pluck(:name)).to eq tag_lists
      end
      it '10文字以下のものは保存する' do
        tag_lists = ['test','test2',Faker::Lorem.characters(number: 10)]
        group.save_tag_group(tag_lists)
        expect(group.tag_groups.pluck(:name)).to eq tag_lists
      end
      it '10文字以上のものは保存しない' do
        tag_lists = ['test','test2',Faker::Lorem.characters(number: 11)]
        group.save_tag_group(tag_lists)
        expect(group.tag_groups.pluck(:name)).to eq ['test','test2']
      end

    end
  end


end