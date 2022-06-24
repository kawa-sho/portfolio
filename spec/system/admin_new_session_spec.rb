require 'rails_helper'

describe '管理者ログイン画面のテスト' do
  before do
    visit new_admin_session_path
  end

  describe '表示内容と遷移先確認' do
    it 'URLが正しい' do
      expect(current_path).to eq (new_admin_session_path)
    end
    it '見出しが正しい' do
      expect(find_all('h2')[0].native.text).to match(/ログイン/)
    end
    it 'emailフォームは表示される' do
      expect(page).to have_field 'admin[email]'
    end
    it 'passwordフォームが表示される' do
      expect(page).to have_field 'admin[password]'
    end
    it 'ログインしたままにするフォームが表示される' do
      expect(page).to have_field 'admin[remember_me]'
    end
    it 'ログインボタンが表示される' do
      expect(page).to have_button 'ログイン'
    end
  end

  describe 'ログインのテスト' do
    let!(:admin) { create(:admin) }
    context 'ログイン成功のテスト' do
      before do
        fill_in 'admin[email]', with: admin.email
        fill_in 'admin[password]', with: admin.password
        click_button 'ログイン'
      end
      it 'ログイン後のリダイレクト先が、ログインした会員の詳細画面になっている' do
        expect(current_path).to eq (admin_root_path)
      end
      it 'ログイン成功のフラッシュメッセージが出ている' do
        expect(page).to have_content('ログインしました')
      end
    end

    context 'ログイン失敗のテスト' do
      context '空欄の場合' do
        before do
          fill_in 'admin[email]', with: ''
          fill_in 'admin[password]', with: ''
          click_button 'ログイン'
        end
        it 'ログインに失敗し、ログインにリダイレクトされる' do
          expect(current_path).to eq (new_admin_session_path)
        end
        it 'フラッシュメッセージの表示' do
          expect(page).to have_content('メールアドレスまたはパスワードが違います。')
        end
      end
    end
  end
end