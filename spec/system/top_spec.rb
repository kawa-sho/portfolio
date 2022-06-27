require 'rails_helper'

describe 'トップ画面のテスト' do
  describe '会員ログイン前' do
    before do
      visit root_path
    end
    context '表示内容と遷移先確認' do
      it 'URLが正しい' do
        expect(current_path).to eq (root_path)
      end
      it 'トップリンクが表示される' do
        link = all(:css, '.header-test')[0].find_all('a')[0].native.attributes['href'].value
        expect(link).to eq '/'
      end
      it 'トップリンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[0].click
        expect(current_path).to eq (root_path)
      end
      it '新規登録リンクが表示される' do
        link = all(:css, '.header-test')[0].find_all('a')[1].native.inner_text
        expect(link).to match(/新規登録/)
      end
      it '新規登録リンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[1].click
        expect(current_path).to eq (new_customer_registration_path)
      end
      it 'ログインリンクが表示される' do
        link = all(:css, '.header-test')[0].find_all('a')[2].native.inner_text
        expect(link).to match(/ログイン/)
      end
      it 'ログインリンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[2].click
        expect(current_path).to eq (new_customer_session_path)
      end
      it 'ゲストログインリンクが表示される' do
        link = all(:css, '.body-test')[0].find_all('a')[0].native.inner_text
        expect(link).to match(/ゲストログイン（閲覧用）/)
      end
      it 'ゲストログインリンクの内容が正しい' do
        all(:css, '.body-test')[0].find_all('a')[0].click
        customer = Customer.find_by(name: "guestcustomer")
        expect(current_path).to eq (customer_path(customer))
        expect(page).to have_content('ゲストでログインしました。')
      end
      it 'ログインリンクが表示される' do
        link = all(:css, '.body-test')[0].find_all('a')[1].native.inner_text
        expect(link).to match(/ログイン/)
      end
      it 'ログインリンクの内容が正しい' do
        all(:css, '.body-test')[0].find_all('a')[1].click
        expect(current_path).to eq (new_customer_session_path)
      end
      it '新規登録リンクが表示される' do
        link = all(:css, '.body-test')[0].find_all('a')[2].native.inner_text
        expect(link).to match(/新規登録/)
      end
      it '新規登録リンクの内容が正しい' do
        all(:css, '.body-test')[0].find_all('a')[2].click
        expect(current_path).to eq (new_customer_registration_path)
      end
    end
  end

  describe '会員ログイン後' do
    let!(:customer) { create(:customer) }
    before do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
      expect(current_path).to eq (customer_path(customer))
      visit root_path
    end
    context '表示内容と遷移先確認' do
      it 'URLが正しい' do
        expect(current_path).to eq (root_path)
      end
      it '管理者ログインに行けない' do
        visit new_admin_session_path
        expect(current_path).to eq (customer_path(customer))
        expect(page).to have_content('すでにログインしています。')
      end
      it 'ログインしている表示がある' do
        expect(page).to have_content(/#{customer.name}でログインしています/)
      end
      it 'トップリンクが表示される' do
        link = all(:css, '.header-test')[0].find_all('a')[0].native.inner_text
        expect(link).to match(//)
      end
      it 'トップリンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[0].click
        expect(current_path).to eq (root_path)
      end
      it 'グループ一覧リンクが表示される' do
        link = all(:css, '.header-test')[0].find_all('a')[1].native.inner_text
        expect(link).to match(/グループ一覧/)
      end
      it 'グループ一覧リンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[1].click
        expect(current_path).to eq (groups_path)
      end
      it 'マイページリンクが表示される' do
        link = all(:css, '.header-test')[0].find_all('a')[2].native.inner_text
        expect(link).to match(/マイページ/)
      end
      it 'マイページリンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[2].click
        expect(current_path).to eq (customer_path(customer))
      end
      it '会員一覧リンクが表示される' do
        link = all(:css, '.header-test')[0].find_all('a')[3].native.inner_text
        expect(link).to match(/会員一覧/)
      end
      it '会員一覧リンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[3].click
        expect(current_path).to eq (customers_path)
      end
      it '投稿一覧リンクが表示される' do
        link = all(:css, '.header-test')[0].find_all('a')[4].native.inner_text
        expect(link).to match(/投稿一覧/)
      end
      it '投稿一覧リンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[4].click
        expect(current_path).to eq (posts_path)
      end
      it 'ログアウトリンクが表示される' do
        link = all(:css, '.header-test')[0].find_all('a')[5].native.inner_text
        expect(link).to match(/ログアウト/)
      end
      it 'ログアウトリンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[5].click
        expect(current_path).to eq (root_path)
        expect(page).to have_content('ログアウトしました')
      end
      it 'ゲストログインリンクが表示される' do
        link = all(:css, '.body-test')[0].find_all('a')[0].native.inner_text
        expect(link).to match(/ゲストログイン/)
      end
      it 'ゲストログインリンクの内容が正しい' do
        all(:css, '.body-test')[0].find_all('a')[0].click
        expect(current_path).to eq (customer_path(customer))
        expect(page).to have_content('すでにログインしています。')
      end
      it 'ログインリンクが表示されるる' do
        link = all(:css, '.body-test')[0].find_all('a')[1].native.inner_text
        expect(link).to match(/ログイン/)
      end
      it 'ログインリンクの内容が正しい' do
        all(:css, '.body-test')[0].find_all('a')[1].click
        expect(current_path).to eq (customer_path(customer))
        expect(page).to have_content('すでにログインしています。')
      end
      it '新規登録リンクが表示される' do
        link = all(:css, '.body-test')[0].find_all('a')[2].native.inner_text
        expect(link).to match(/新規登録/)
      end
      it '新規登録リンクの内容が正しい' do
        all(:css, '.body-test')[0].find_all('a')[2].click
        expect(current_path).to eq (customer_path(customer))
        expect(page).to have_content('すでにログインしています。')
      end
    end
  end

  describe '管理者ログイン後' do
    let!(:admin) { create(:admin) }
    before do
      visit new_admin_session_path
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
      expect(current_path).to eq (admin_root_path)
      visit root_path
    end
    context '表示内容と遷移先確認' do
      it 'URLが正しい' do
        expect(current_path).to eq (root_path)
      end
      it 'トップリンクが表示される' do
        top_link = all(:css, '.header-test')[0].find_all('a')[0].native.inner_text
        expect(top_link).to match(//)
      end
      it 'トップリンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[0].click
        expect(current_path).to eq (root_path)
      end
      it 'グループ一覧リンクが表示される' do
        link = all(:css, '.header-test')[0].find_all('a')[1].native.inner_text
        expect(link).to match(/グループ一覧/)
      end
      it 'グループ一覧リンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[1].click
        expect(current_path).to eq (admin_groups_path)
      end
      it '会員一覧リンクが表示される' do
        link = all(:css, '.header-test')[0].find_all('a')[2].native.inner_text
        expect(link).to match(/会員一覧/)
      end
      it '会員一覧リンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[2].click
        expect(current_path).to eq (admin_root_path)
      end
      it '投稿一覧リンクが表示される' do
        link = all(:css, '.header-test')[0].find_all('a')[3].native.inner_text
        expect(link).to match(/投稿一覧/)
      end
      it '投稿一覧リンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[3].click
        expect(current_path).to eq (admin_posts_path)
      end
      it 'ログアウトリンクが表示される' do
        link = all(:css, '.header-test')[0].find_all('a')[4].native.inner_text
        expect(link).to match(/ログアウト/)
      end
      it 'ログアウトリンクの内容が正しい' do
        all(:css, '.header-test')[0].find_all('a')[4].click
        expect(current_path).to eq (root_path)
        expect(page).to have_content('ログアウトしました')
      end
      it 'ゲストログインリンクが表示される' do
        link = all(:css, '.body-test')[0].find_all('a')[0].native.inner_text
        expect(link).to match(/ゲストログイン/)
      end
      it 'ゲストログインリンクの内容が正しい' do
        all(:css, '.body-test')[0].find_all('a')[0].click
        expect(current_path).to eq (admin_root_path)
        expect(page).to have_content('すでにログインしています。')
      end
      it 'ログインリンクが表示される' do
        link = all(:css, '.body-test')[0].find_all('a')[1].native.inner_text
        expect(link).to match(/ログイン/)
      end
      it 'ログインリンクの内容が正しい' do
        all(:css, '.body-test')[0].find_all('a')[1].click
        expect(current_path).to eq (admin_root_path)
        expect(page).to have_content('すでにログインしています。')
      end
      it '新規登録リンクが表示される' do
        link = all(:css, '.body-test')[0].find_all('a')[2].native.inner_text
        expect(link).to match(/新規登録/)
      end
      it '新規登録リンクの内容が正しい' do
        all(:css, '.body-test')[0].find_all('a')[2].click
        expect(current_path).to eq (admin_root_path)
        expect(page).to have_content('すでにログインしています。')
      end
    end
  end
end