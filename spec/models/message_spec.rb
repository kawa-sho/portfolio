require 'rails_helper'

RSpec.describe 'Messageモデルのテスト', type: :model do

  describe 'バリデーションのテスト' do
    subject { message.valid? }
    let(:customer) { create(:customer) }
    let(:room) { create(:room) }
    let!(:message) { create(:message, customer_id: customer.id, room_id: room.id) }

    context 'messageカラム' do
      it '1文字以上であること: 0文字は×' do
        message.message = Faker::Lorem.characters(number: 0)
        is_expected.to eq false
      end
      it '1文字以上であること: 1文字は〇' do
        message.message = Faker::Lorem.characters(number: 1)
        is_expected.to eq true
      end
      it '100文字以下であること: 100文字は〇' do
        message.message = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it '100文字以下であること: 101文字は×' do
        message.message = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
  end

  describe '並べ変えのテスト' do
    let(:customer) { create(:customer) }
    let(:room) { create(:room) }
    let!(:first_message) { create(:message, customer_id: customer.id, room_id: room.id, created_at: Time.current - 1.hour) }
    let!(:second_message) { create(:message, customer_id: customer.id, room_id: room.id, created_at: Time.current + 1.hour) }
    let!(:third_message) { create(:message, customer_id: customer.id, room_id: room.id ) }
    context 'latest' do
        subject { Message.latest }
      it do
        is_expected.to eq [second_message, third_message, first_message]
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'customerモデルとの関係' do
      it '1:Nとなっている' do
        expect(Message.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end
    context 'roomモデルとの関係' do
      it '1:Nとなっている' do
        expect(Message.reflect_on_association(:room).macro).to eq :belongs_to
      end
    end
  end
end