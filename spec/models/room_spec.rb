require 'rails_helper'

RSpec.describe 'Roomモデルのテスト', type: :model do

  describe 'アソシエーションのテスト' do
    context 'messagesモデルとの関係' do
      it '1:Nとなっている' do
        expect(Room.reflect_on_association(:messages).macro).to eq :has_many
      end
    end
    context 'entriesモデルとの関係' do
      it '1:Nとなっている' do
        expect(Room.reflect_on_association(:entries).macro).to eq :has_many
      end
    end
  end

  describe '並べ変えのテスト' do
    let!(:first_room) { create(:room, updated_at: Time.current - 1.hour) }
    let!(:second_room) { create(:room, updated_at: Time.current + 1.hour) }
    let!(:third_room) { create(:room ) }
    context 'latest' do
        subject { Room.latest }
      it do
        is_expected.to eq [second_room, third_room, first_room]
      end
    end
  end
end