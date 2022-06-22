require 'rails_helper'

RSpec.describe 'Entryモデルのテスト', type: :model do

  describe 'アソシエーションのテスト' do
    context 'customerモデルとの関係' do
      it '1:Nとなっている' do
        expect(Entry.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context 'roomモデルとの関係' do
      it '1:Nとなっている' do
        expect(Entry.reflect_on_association(:room).macro).to eq :belongs_to
      end
    end
  end

end