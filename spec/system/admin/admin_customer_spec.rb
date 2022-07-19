require 'rails_helper'

describe '管理者側会員詳細画面のテスト' do
  let!(:admin) { create(:admin) }
  let!(:customer) { create(:customer) }
  let!(:customer2) { create(:customer) }
  let!(:customer3) { create(:customer, is_active: false) }
  let(:guest) { Customer.find_by(name: 'guestcustomer') }

  describe '会員詳細画面' do
    before do
      visit root_path
      all(:css, '.body-test')[0].find_all('a')[0].click
      all(:css, '.header-test')[0].find_all('a')[5].click
      visit new_admin_session_path
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
      visit admin_customer_path(customer)
    end

    describe '会員詳細の表示内容と遷移先確認' do
      it 'URLが正しい' do
        expect(current_path).to eq (admin_customer_path(customer))
      end
      it '見出しが正しい' do
        expect(all(:css, ".midashi")[0].native.text).to match(/会員詳細ページ/)
      end
      it '会員情報の画像が正しい' do
        profile_image = all(:css, ".customer-profile-test")[0].native.children[1].children[0].attributes["src"].value
        expect(profile_image).to match("/assets/no_image")
      end
      it '会員情報の名前が正しい' do
        profile_name = all(:css, ".customer-profile-test")[0].native.text
        expect(profile_name).to match(/#{customer.name}/)
      end
      it "会員情報の有効がきちんと表示されている" do
        is_active = all(:css, ".is_active-test")[0].native.children[3].text
        expect(is_active).to eq "有効"
      end
      it "退会していた場合退会になる" do
        visit admin_customer_path(customer3)
        is_active = all(:css, ".is_active-test")[0].native.children[3].text
        expect(is_active).to eq "退会"
      end
      it '自己紹介がきちんと表示されているか' do
        profile_name = all(:css, ".customer-introduction-test")[0].native.text
        expect(profile_name).to match(/#{customer.introduction}/)
      end
      it 'フォロー数リンクが表示される' do
        link = all(:css, ".follow-index-btn-test")[0].find_all("a")[0].native.text
        expect(link).to match(/フォロー数: #{customer.followings.count}/)
      end
      it 'フォロー数リンクの内容が正しい' do
        all(:css, ".follow-index-btn-test")[0].find_all("a")[0].click
        expect(current_path).to eq (admin_customer_followings_path(customer))
      end
      it 'フォロー数が増える' do
        expect { create(:relationship,follower_id: customer.id, followed_id: customer2.id) }.to change{customer.followings.count}.by(1)
        visit admin_customer_path(customer)
        link = all(:css, ".follow-index-btn-test")[0].find_all("a")[0].native.text
        expect(link).to match(/フォロー数: 1/)
      end
      it 'フォロワー数リンクが表示される' do
        link = all(:css, ".follow-index-btn-test")[0].find_all("a")[1].native.text
        expect(link).to match(/フォロワー数: #{customer.followers.count}/)
      end
      it 'フォロワー数リンクの内容が正しい' do
        all(:css, ".follow-index-btn-test")[0].find_all("a")[1].click
        expect(current_path).to eq (admin_customer_followers_path(customer))
      end
      it 'フォロワー数が増える' do
        expect { create(:relationship,follower_id: customer2.id, followed_id: customer.id) }.to change{customer.followers.count}.by(1)
        visit admin_customer_path(customer)
        link = all(:css, ".follow-index-btn-test")[0].find_all("a")[1].native.text
        expect(link).to match(/フォロワー数: 1/)
      end
      it "通報一覧リンクが表示される" do
        link = all(:css, ".report-test")[0].find_all("a")[2].native.text
        expect(link).to match(/通報一覧: #{customer.reported.count}/)
      end
      it '通報一覧リンクの内容が正しい' do
        all(:css, ".report-test")[0].find_all("a")[2].click
        expect(current_path).to eq (admin_customer_reported_path(customer))
      end
      it '通報数が増える' do
        expect { create(:report,reports_id: customer2.id, reported_id: customer.id) }.to change{customer.reported.count}.by(1)
        visit admin_customer_path(customer)
        link = all(:css, ".follow-index-btn-test")[0].find_all("a")[2].native.text
        expect(link).to match(/通報一覧: 1/)
      end
      it '編集するリンクが表示される' do
        link = all(:css, ".customer-edit-btn-test")[0].find_all("a")[0].native.text
        expect(link).to match(/編集する/)
      end
      it '編集するリンクの内容が正しい' do
        all(:css, ".customer-edit-btn-test")[0].find_all("a")[0].click
        expect(current_path).to eq (edit_admin_customer_path(customer))
      end
      it "ゲスト会員の場合編集するが表示されない" do
        visit admin_customer_path(guest)
        expect(all(:css, ".customer-edit-btn-test")[0]).to eq nil
      end
      it "ゲスト会員の場合編集する画面に遷移できない" do
        visit edit_admin_customer_path(guest)
        expect(current_path).to eq (admin_root_path)
        expect(page).to have_content('ゲストユーザーのプロフィール編集画面へ遷移できません')
      end
      it 'お気に入りグループリンクが表示される' do
        link = all(:css, ".group-btn-test")[0].find_all("a")[0].native.text
        expect(link).to match(/お気に入りグループ/)
      end
      it 'お気に入りグループリンクの内容が正しい' do
        all(:css, ".group-btn-test")[0].find_all("a")[0].click
        expect(current_path).to eq (admin_customer_group_favorites_path(customer))
      end
      it '作成したグループリンクが表示される' do
        link = all(:css, ".group-btn-test")[0].find_all("a")[1].native.text
        expect(link).to match(/作成したグループ/)
      end
      it '作成したグループリンクの内容が正しい' do
        all(:css, ".group-btn-test")[0].find_all("a")[1].click
        expect(current_path).to eq (admin_customer_groups_path(customer))
      end
      it 'いいね一覧リンクが表示される' do
        link = all(:css, ".index-btn-test")[0].find_all("a")[0].native.text
        expect(link).to match(/いいね一覧/)
      end
      it 'いいね一覧リンクの内容が正しい' do
        all(:css, ".index-btn-test")[0].find_all("a")[0].click
        expect(current_path).to eq (admin_customer_post_favorites_path(customer))
      end
      it 'コメント一覧リンクが表示される' do
        link = all(:css, ".index-btn-test")[0].find_all("a")[1].native.text
        expect(link).to match(/コメント一覧/)
      end
      it 'コメント一覧へリンクの内容が正しい' do
        all(:css, ".index-btn-test")[0].find_all("a")[1].click
        expect(current_path).to eq (admin_customer_post_comments_path(customer))
      end
    end


    describe '会員詳細ページの投稿一覧の表示内容と遷移先確認' do
      context '投稿が存在しないとき' do
        it '見出しの確認' do
          expect(all(:css, ".midashi")[1].native.text).to match(/#{customer.name}の投稿一覧/)
        end
        it '投稿が存在しない場合の表示' do
          expect(page).to have_content(/#{customer.name}の投稿が存在しません/)
        end
      end

      context '投稿が存在する場合' do
        let!(:posts) { create_list(:post,21,customer_id: customer.id) }
        let!(:tag_post) { create(:tag_post) }
        let!(:post_tag_post) { create(:post_tag_post,post_id: posts.last.id, tag_post_id: tag_post.id) }
        before do
          visit admin_customer_path(customer)
        end
        it '会員リンクが表示される' do
          link = all(:css, ".customer-profile-test")[1].native.text
          expect(link).to match(/#{customer.name}/)
        end
        it '会員リンクの内容が正しい' do
          all(:css, ".customer-profile-test")[1].click
          expect(current_path).to eq (admin_customer_path(customer))
        end
        it '投稿の表示が正しい' do
          expect(all(:css, ".post-test")[0].text).to match(/#{posts.last.post}/)
        end
        it 'タグリンクが表示される' do
          link = all(:css, ".tag-test")[0].native.inner_text
          expect(link).to match(/#{tag_post.name}/)
        end
        it 'タグリンクの内容が正しい' do
          all(:css, ".tag-test")[0].click
          expect(current_path).to eq (admin_tag_search_path)
        end
        it 'タグリンクで遷移した先で検索がかかっている' do
          all(:css, ".tag-test")[0].click
          expect(page).to have_content("タグ(#{tag_post.name})で検索中")
        end
        it 'いいねリンクが表示される' do
          link = all(:css, ".favorite-test")[0].find_all("a")[0].native.text
          expect(link).to match(/0いいね/)
        end
        it 'いいねリンクの内容が正しい' do
          all(:css, ".favorite-test")[0].find_all("a")[0].click
          expect(current_path).to eq (admin_post_post_favorites_path(posts.last))
        end
        it 'いいねの数が増える' do
          expect { create(:post_favorite,customer_id: customer2.id, post_id: posts.last.id) }.to change{posts.last.post_favorites.count}.by(1)
          visit admin_customer_path(customer)
          link = all(:css, ".favorite-test")[0].find_all("a")[0].native.text
          expect(link).to match(/1いいね/)
        end
        context 'コメント関連' do
          let!(:post_comment) { create(:post_comment, customer_id: customer2.id, post_id: posts.last.id) }
          it 'コメントリンクが表示される' do
            link = all(:css, ".comment-test")[0].native.text
            expect(link).to match(/0コメント/)
          end
          it 'コメントリンクの内容が正しい' do
            all(:css, ".comment-test")[0].click
            expect(current_path).to eq (admin_post_path(posts.last))
          end
          it 'コメントの数が切り替わる' do
            visit admin_customer_path(customer)
            expect(all(:css, ".comment-test")[0].native.text).to match(/1コメント/)
          end
        end
        it '日付表示の確認' do
          link = all(:css, ".created-test")[0].native.text
          created_at = posts.last.created_at.to_s(:datetime_jp)
          expect(link).to match(created_at)
        end
        it "ページネーションが表示される" do
          link = all(:css, ".pagination")[0].find_all("a")[1].native.text
          expect(link).to eq ('2')
        end
        it "ページネーションが機能する" do
          all(:css, ".pagination")[0].find_all("a")[1].click
          expect(current_url).to match("page=2")
        end
      end
    end
  end
end