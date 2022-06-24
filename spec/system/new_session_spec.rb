require 'rails_helper'

describe 'ログイン画面のテスト' do
  before do
    visit new_customer_session_path
  end

  describe '表示内容と遷移先確認' do
    it 'URLが正しい' do
      expect(current_path).to eq (new_customer_session_path)
    end
    it '見出しが正しい' do
      expect(find_all('h2')[0].native.text).to match(/ログイン/)
    end
    it 'nameフォームが表示されない' do
      expect(page).not_to have_field 'customer[name]'
    end
    it 'emailフォームは表示される' do
      expect(page).to have_field 'customer[email]'
    end
    it 'passwordフォームが表示される' do
      expect(page).to have_field 'customer[password]'
    end
    it 'introductionフォームが表示されない' do
      expect(page).not_to have_field 'customer[introduction]'
    end
    it 'is_activeフォームが表示されない' do
      expect(page).not_to have_field 'customer[is_active]'
    end
    it 'ログインしたままにするフォームが表示される' do
      expect(page).to have_field 'customer[remember_me]'
    end
    it 'ログインボタンが表示される' do
      expect(page).to have_button 'ログイン'
    end
    it '新規登録リンクが表示される: 左上から3番目のリンクが「新規登録」である' do
      link = find_all('a')[3].native.inner_text
      expect(link).to match(/新規登録/)
    end
    it '新規登録リンクの内容が正しい' do
      find_all('a')[3].click
      expect(current_path).to eq (new_customer_registration_path)
    end
  end

  describe 'ログインのテスト' do
    let!(:customer) { create(:customer) }
    let!(:customer_false) { create(:customer,is_active: false) }
    context 'ログイン成功のテスト' do
      before do
        fill_in 'customer[email]', with: customer.email
        fill_in 'customer[password]', with: customer.password
        click_button 'ログイン'
      end
      it 'ログイン後のリダイレクト先が、ログインした会員の詳細画面になっている' do
        expect(current_path).to eq (customer_path(customer))
      end
      it 'ログイン成功のフラッシュメッセージが出ている' do
        expect(page).to have_content('ログインしました')
      end
    end

    context '退会してる会員でログインのテスト' do
      before do
        fill_in 'customer[email]', with: customer_false.email
        fill_in 'customer[password]', with: customer_false.password
        click_button 'ログイン'
      end

      it 'ログインに失敗し、新規登録画面にリダイレクトされる' do
        expect(current_path).to eq (new_customer_registration_path)
      end
      it 'フラッシュメッセージの表示' do
        expect(page).to have_content('退会済みです')
      end
    end

    context 'ログイン失敗のテスト' do
      context '空欄の場合' do
        before do
          fill_in 'customer[email]', with: ''
          fill_in 'customer[password]', with: ''
          click_button 'ログイン'
        end
        it 'ログインに失敗し、ログインにリダイレクトされる' do
          expect(current_path).to eq (new_customer_session_path)
        end
        it 'フラッシュメッセージの表示' do
          expect(page).to have_content('メールアドレスまたはパスワードが違います。')
        end
      end
    end
  end
end