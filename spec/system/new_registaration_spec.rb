require 'rails_helper'

describe '新規登録画面のテスト' do
  before do
    visit new_customer_registration_path
  end

  describe '表示内容と遷移先確認' do
    it 'URLが正しい' do
      expect(current_path).to eq (new_customer_registration_path)
    end
    it '見出しが正しい' do
      expect(find_all('h2')[0].native.text).to match(/新規会員登録/)
    end
    it 'nameフォームが表示される' do
      expect(page).to have_field 'customer[name]'
    end
    it 'emailフォームは表示される' do
      expect(page).to have_field 'customer[email]'
    end
    it 'passwordフォームが表示される' do
      expect(page).to have_field 'customer[password]'
    end
    it 'passwordフォームが表示される' do
      expect(page).to have_field 'customer[password_confirmation]'
    end
    it 'introductionフォームが表示されない' do
      expect(page).not_to have_field 'customer[introduction]'
    end
    it 'is_activeフォームが表示されない' do
      expect(page).not_to have_field 'customer[is_active]'
    end
    it '新規登録ボタンが表示される' do
      expect(page).to have_button '新規登録'
    end
    it 'ログインリンクが表示される: 左上から3番目のリンクが「ログイン」である' do
      link = find_all('a')[3].native.inner_text
      expect(link).to match(/ログイン/)
    end
    it 'ログインリンクの内容が正しい' do
      find_all('a')[3].click
      expect(current_path).to eq (new_customer_session_path)
    end
  end

  describe '新規登録のテスト' do
    context '新規登録成功のテスト' do
      before do
        fill_in 'customer[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'customer[email]', with: Faker::Internet.email
        fill_in 'customer[password]', with: 'password'
        fill_in 'customer[password_confirmation]', with: 'password'
      end
      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(Customer.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録した会員の詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq (customer_path(Customer.last.id))
      end
      it '新規登録成功のフラッシュメッセージが出ている' do
        click_button '新規登録'
        expect(page).to have_content('アカウント登録が完了しました。')
      end
    end
    context '新規登録失敗のテスト' do
      context 'すべて入力がない場合' do
      before do
        fill_in 'customer[name]', with: ''
        fill_in 'customer[email]', with: ''
        fill_in 'customer[password]', with: ''
        fill_in 'customer[password_confirmation]', with: ''
        click_button '新規登録'
      end
        # it '新規登録画面にいる' do
        #   expect(current_path).to eq (new_customer_registration_path)
        # end
        it 'エラーが3つ表示される' do
          expect(page).to have_content('3件のエラーが発生しました')
          expect(page).to have_content('ニックネームは1文字以上で入力してください')
          expect(page).to have_content('メールアドレスを入力してください')
          expect(page).to have_content('パスワードを入力してください')
        end
      end
      context '名前が21文字以上でパスワードが5文字以下で入力した場合' do
      before do
        fill_in 'customer[name]', with: Faker::Lorem.characters(number: 21)
        fill_in 'customer[email]', with: ''
        fill_in 'customer[password]', with: Faker::Lorem.characters(number: 5)
        fill_in 'customer[password_confirmation]', with: ''
        click_button '新規登録'
      end
        # it '新規登録画面にいる' do
        #   expect(current_path).to eq (new_customer_registration_path)
        # end
        it 'エラーが4つ表示される' do
          expect(page).to have_content('4件のエラーが発生しました')
          expect(page).to have_content('ニックネームは20文字以内で入力してください')
          expect(page).to have_content('メールアドレスを入力してください')
          expect(page).to have_content('Password confirmationとパスワードの入力が一致しません')
          expect(page).to have_content('パスワードは6文字以上で入力してください')
        end
      end
    end
  end

end


