require 'rails_helper'

RSpec.describe 'Reportモデルのテスト', type: :model do

  describe 'バリデーションのテスト' do
    subject { report.valid? }
    let(:customer) { create(:customer) }
    let(:customer2) { create(:customer) }
    let!(:report) { create(:report, reports_id: customer.id, reported_id: customer2.id) }

    context 'messageカラム' do
      it '2文字以上であること: 1文字は×' do
        report.message = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '2文字以上であること: 2文字は〇' do
        report.message = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
      it '200文字以下であること: 200文字は〇' do
        report.message = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it '200文字以下であること: 201文字は×' do
        report.message = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'reportsモデルとの関係' do
      it '1:Nとなっている' do
        expect(Report.reflect_on_association(:reports).macro).to eq :belongs_to
      end
    end
    context 'reportedモデルとの関係' do
      it '1:Nとなっている' do
        expect(Report.reflect_on_association(:reported).macro).to eq :belongs_to
      end
    end
  end

  describe '並べ変えのテスト' do
    let(:customer) { create(:customer) }
    let(:customer2) { create(:customer) }
    let(:customer3) { create(:customer) }
    let!(:first_report) { create(:report, reports_id: customer2.id, reported_id: customer.id, created_at: Time.current - 1.hour) }
    let!(:second_report) { create(:report, reports_id: customer.id, reported_id: customer2.id, created_at: Time.current + 1.hour) }
    let!(:third_report) { create(:report, reports_id: customer.id, reported_id: customer3.id, ) }
    context 'latest' do
      subject { Report.latest }
      it do
        is_expected.to eq [second_report, third_report, first_report]
      end
    end
    context 'self.reported_count' do
      let!(:report) { create(:report, reports_id: customer.id, reported_id: customer3.id, ) }
      let!(:report2) { create(:report, reports_id: customer.id, reported_id: customer2.id, ) }
      let!(:report3) { create(:report, reports_id: customer.id, reported_id: customer2.id, ) }
      subject { Report.reported_count }
      it do
        is_expected.to eq [second_report, third_report, first_report]
      end
    end

  end
end