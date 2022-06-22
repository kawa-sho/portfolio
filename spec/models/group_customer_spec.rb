require 'rails_helper'

RSpec.describe 'GroupCustomerモデルのテスト', type: :model do

  describe 'アソシエーションのテスト' do
    context 'customerモデルとの関係' do
      it '1:Nとなっている' do
        expect(GroupCustomer.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context 'groupモデルとの関係' do
      it '1:Nとなっている' do
        expect(GroupCustomer.reflect_on_association(:group).macro).to eq :belongs_to
      end
    end
  end

end