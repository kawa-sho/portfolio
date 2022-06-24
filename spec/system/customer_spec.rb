require 'rails_helper'

describe '会員詳細画面のテスト' do
  let!(:customer) { create(:customer) }
  let!(:customer2) { create(:customer) }
  let!(:post) { create(:post,customer_id: customer.id) }
  let!(:post2) { create(:post,customer_id: customer.id) }
  let!(:post3) { create(:post,customer_id: customer.id) }
  let!(:post4) { create(:post,customer_id: customer.id) }
  let!(:post5) { create(:post,customer_id: customer.id) }
  let!(:post6) { create(:post,customer_id: customer.id) }
  let!(:post7) { create(:post,customer_id: customer.id) }
  let!(:post8) { create(:post,customer_id: customer.id) }
  let!(:post9) { create(:post,customer_id: customer.id) }
  let!(:post10) { create(:post,customer_id: customer.id) }
  let!(:post11) { create(:post,customer_id: customer.id) }
  let!(:tag_post) { create(:tag_post) }
  let!(:post_tag_post) { create(:post_tag_post,post_id: post.id, tag_post_id: tag_post.id) }

  describe '自分の会員詳細画面' do
    before do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
      visit customer_path(customer)
    end

    describe '表示内容と遷移先確認' do
      it 'URLが正しい' do
        expect(current_path).to eq (customer_path(customer))
      end
      it '見出しが正しい' do
        expect(find_all('h2')[0].native.text).to match(/会員詳細ページ/)
      end
      it 'フォロー数リンクが表示される: 左上から6番目のリンクが「フォロー数」である' do
        link = find_all('a')[6].native.inner_text
        expect(link).to match(/フォロー数: #{customer.followings.count}/)
      end
      it 'フォロー数リンクの内容が正しい' do
        find_all('a')[6].click
        expect(current_path).to eq (customer_followings_path(customer))
      end
      let(:relationship) { create(:relationship,follower_id: customer.id, followed_id: customer2.id) }
      it 'フォロー数が増える' do
        expect { relationship }.to change{customer.followings.count}.by(1)
      end
    end
  end

end