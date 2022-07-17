require 'rails_helper'

describe '会員詳細画面のテスト(ゲストログイン時)' do
  let!(:customer) { create(:customer) }
  let(:guest) { Customer.find_by(name: 'guestcustomer') }

  describe '自分の会員詳細画面' do
    before do
      visit root_path
      all(:css, '.body-test')[0].find_all('a')[0].click
      visit customer_path(guest)
    end

    describe '会員詳細の表示内容と遷移先確認' do
      it 'URLが正しい' do
        expect(current_path).to eq (customer_path(guest.id))
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
        expect(profile_name).to match(/#{guest.name}/)
      end
      it '自己紹介がきちんと表示されているか' do
        profile_name = all(:css, ".customer-introduction-test")[0].native.text
        expect(profile_name).to match(/#{guest.introduction}/)
      end
      it 'フォロー数リンクが表示される' do
        link = all(:css, ".follow-index-btn-test")[0].find_all("a")[0].native.text
        expect(link).to match(/フォロー数: #{guest.followings.count}/)
      end
      it 'フォロー数リンクの内容が正しい' do
        all(:css, ".follow-index-btn-test")[0].find_all("a")[0].click
        expect(current_path).to eq (customer_followings_path(guest))
      end
      it 'フォロー数が増える' do
        expect { create(:relationship,follower_id: guest.id, followed_id: customer.id) }.to change{guest.followings.count}.by(1)
        visit customer_path(guest)
        link = all(:css, ".follow-index-btn-test")[0].find_all("a")[0].native.text
        expect(link).to match(/フォロー数: 1/)
      end
      it 'フォロワー数リンクが表示される' do
        link = all(:css, ".follow-index-btn-test")[0].find_all("a")[1].native.text
        expect(link).to match(/フォロワー数: #{guest.followers.count}/)
      end
      it 'フォロワー数リンクの内容が正しい' do
        all(:css, ".follow-index-btn-test")[0].find_all("a")[1].click
        expect(current_path).to eq (customer_followers_path(guest))
      end
      it 'フォロワー数が増える' do
        expect { create(:relationship,follower_id: customer.id, followed_id: guest.id) }.to change{guest.followers.count}.by(1)
        visit customer_path(guest)
        link = all(:css, ".follow-index-btn-test")[0].find_all("a")[1].native.text
        expect(link).to match(/フォロワー数: 1/)
      end
      it '編集するリンクが表示されない' do
        expect(all(:css, ".customer-edit-btn-test")[0]).to eq nil
      end
      it "編集する画面に遷移できない" do
        visit edit_customer_path(guest)
        expect(current_path).to eq (customer_path(guest))
        expect(page).to have_content('ゲストユーザーはプロフィール編集画面へ遷移できません')
      end
      it '新着メッセージへリンクが表示される' do
        link = all(:css, ".dm-btn-test")[0].find_all("a")[0].native.text
        expect(link).to match(/新着メッセージへ/)
      end
      it '新着メッセージへリンクの内容が正しい' do
        all(:css, ".dm-btn-test")[0].find_all("a")[0].click
        expect(current_path).to eq (messages_path)
      end
      it '新着メッセージがない場合のクラス' do
        link = all(:css, ".dm-btn-test")[0].find_all("a")[0].native.attributes['class'].value
        expect(link).to eq ("btn btn-primary")
      end
      it '新着メッセージがある場合のクラス' do
        room = create(:room)
        create(:entry,customer_id: guest.id, room_id: room.id)
        create(:entry,customer_id: customer.id, room_id: room.id)
        create(:message,room_id: room.id,customer_id: customer.id)
        create(:relationship,follower_id: customer.id, followed_id: guest.id)
        visit customer_path(guest)
        new_dm_btn = all(:css, ".dm-btn-test")[0].find_all("a")[0].native.attributes['class'].value
        expect(new_dm_btn).to eq ("btn btn-danger")
      end
      it 'DMルーム一覧へリンクが表示される' do
        link = all(:css, ".dm-btn-test")[0].find_all("a")[1].native.text
        expect(link).to match(/DMルーム一覧へ/)
      end
      it 'DMルーム一覧へリンクの内容が正しい' do
        all(:css, ".dm-btn-test")[0].find_all("a")[1].click
        expect(current_path).to eq (rooms_path)
      end
      it 'お気に入りグループリンクが表示される' do
        link = all(:css, ".group-btn-test")[0].find_all("a")[0].native.text
        expect(link).to match(/お気に入りグループ/)
      end
      it 'お気に入りグループリンクの内容が正しい' do
        all(:css, ".group-btn-test")[0].find_all("a")[0].click
        expect(current_path).to eq (customer_group_favorites_path(guest))
      end
      it '作成したグループリンクが表示される' do
        link = all(:css, ".group-btn-test")[0].find_all("a")[1].native.text
        expect(link).to match(/作成したグループ/)
      end
      it '作成したグループリンクの内容が正しい' do
        all(:css, ".group-btn-test")[0].find_all("a")[1].click
        expect(current_path).to eq (customer_groups_path(guest))
      end
      it 'いいね一覧リンクが表示される' do
        link = all(:css, ".index-btn-test")[0].find_all("a")[0].native.text
        expect(link).to match(/いいね一覧/)
      end
      it 'いいね一覧リンクの内容が正しい' do
        all(:css, ".index-btn-test")[0].find_all("a")[0].click
        expect(current_path).to eq (customer_post_favorites_path(guest))
      end
      it 'コメント一覧リンクが表示される' do
        link = all(:css, ".index-btn-test")[0].find_all("a")[1].native.text
        expect(link).to match(/コメント一覧/)
      end
      it 'コメント一覧へリンクの内容が正しい' do
        all(:css, ".index-btn-test")[0].find_all("a")[1].click
        expect(current_path).to eq (customer_post_comments_path(guest))
      end
    end


    describe '会員詳細ページの投稿一覧の表示内容と遷移先確認' do
      context '投稿が存在しないとき' do
        it '見出しの確認' do
          expect(all(:css, ".midashi")[1].native.text).to match(/#{guest.name}の投稿一覧/)
        end
        it '投稿が存在しない場合の表示' do
          expect(page).to have_content(/#{guest.name}の投稿が存在しません/)
        end
      end

      context '投稿が存在する場合' do
        let!(:posts) { create_list(:post,21,customer_id: guest.id) }
        let!(:tag_post) { create(:tag_post) }
        let!(:post_tag_post) { create(:post_tag_post,post_id: posts.last.id, tag_post_id: tag_post.id) }
        before do
          visit customer_path(guest)
        end
        it '会員リンクが表示される' do
          link = all(:css, ".customer-profile-test")[1].native.text
          expect(link).to match(/#{guest.name}/)
        end
        it '会員リンクの内容が正しい' do
          all(:css, ".customer-profile-test")[1].click
          expect(current_path).to eq (customer_path(guest))
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
          expect(current_path).to eq (tag_search_path)
        end
        it 'タグリンクで遷移した先で検索がかかっている' do
          all(:css, ".tag-test")[0].click
          expect(page).to have_content("タグ(#{tag_post.name})で検索中")
        end
        it '♥リンクが表示される' do
          link = all(:css, ".favorite-test")[0].native.children[1].text
          expect(link).to match(/♥/)
        end
        it '♥リンクをクリックする前のクラス' do
          expect(all(:css, ".favorite-test")[0].native.children[1].attributes['class'].value).to eq ("favorite-black")
        end
        it '♥リンクをクリックした後のクラス非同期', js: true do
          link = all(:css, ".favorite-test")[0].native.find_element(:css, ".favorite-black")
          link.send_keys :tab
          link.click
          sleep 0.5
          expect(all(:css, ".favorite-test")[0].native.find_element(:css, ".favorite-red").attribute("class")).to eq "favorite-red"
        end
        it '♥リンクの内容が正しい', js: true do
          expect(guest.post_favorites.count).to eq 0
          link = all(:css, ".favorite-test")[0].native.find_element(:css, ".favorite-black")
          link.send_keys :tab
          link.click
          sleep 0.5
          expect(guest.post_favorites.count).to eq 1
        end
        it 'いいねリンクが表示される' do
          link = all(:css, ".favorite-test")[0].find_all("a")[1].native.text
          expect(link).to match(/0いいね/)
        end
        it 'いいねリンクの内容が正しい' do
          all(:css, ".favorite-test")[0].find_all("a")[1].click
          expect(current_path).to eq (post_post_favorites_path(posts.last))
        end
        it 'いいねの数が切り替わる', js: true do
          link = all(:css, ".favorite-test")[0].native.find_element(:css, ".favorite-black")
          link.send_keys :tab
          link.click
          sleep 0.5
          expect(all(:css, ".favorite-test")[0].find_all("a")[1].native.text).to match(/1いいね/)
        end
        context 'コメント関連' do
          let!(:post_comment) { create(:post_comment, customer_id: guest.id, post_id: posts.last.id) }
          it 'コメントリンクが表示される' do
            link = all(:css, ".comment-test")[0].native.text
            expect(link).to match(/0コメント/)
          end
          it 'コメントリンクの内容が正しい' do
            all(:css, ".comment-test")[0].click
            expect(current_path).to eq (post_path(posts.last))
          end
          it 'コメントの数が切り替わる' do
            visit customer_path(guest)
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


#------------------------------------------------------------------------------------------

  describe '他人の会員詳細画面' do
    let!(:customer3) { create(:customer, is_active: false) }
    before do
      visit root_path
      all(:css, '.body-test')[0].find_all('a')[0].click
      visit customer_path(customer)
    end

    describe '会員詳細の表示内容と遷移先確認' do
      it 'URLが正しい' do
        expect(current_path).to eq (customer_path(customer))
      end
      it '退会してる場合退会していますとでる' do
        visit customer_path(customer3)
        expect(page).to have_content('このアカウントは退会済みです。')
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
        expect(current_path).to eq (customer_followings_path(customer))
      end
      it 'フォロー数が増える' do
        expect { create(:relationship,follower_id: customer.id, followed_id: guest.id) }.to change{customer.followings.count}.by(1)
        visit customer_path(customer)
        link = all(:css, ".follow-index-btn-test")[0].find_all("a")[0].native.text
        expect(link).to match(/フォロー数: 1/)
      end
      it 'フォロワー数リンクが表示される' do
        link = all(:css, ".follow-index-btn-test")[0].find_all("a")[1].native.text
        expect(link).to match(/フォロワー数: #{customer.followers.count}/)
      end
      it 'フォロワー数リンクの内容が正しい' do
        all(:css, ".follow-index-btn-test")[0].find_all("a")[1].click
        expect(current_path).to eq (customer_followers_path(customer))
      end
      it 'フォロワー数が増える' do
        expect { create(:relationship,follower_id: guest.id, followed_id: customer.id) }.to change{customer.followers.count}.by(1)
        visit customer_path(customer)
        link = all(:css, ".follow-index-btn-test")[0].find_all("a")[1].native.text
        expect(link).to match(/フォロワー数: 1/)
      end
      it "フォローするリンクが表示される" do
        link = all(:css, ".follow-test")[0].find_all("a")[0].native.text
        expect(link).to match(/フォローする/)
      end
      it "フォローするリンクの内容が正しい" do
        all(:css, ".follow-test")[0].find_all("a")[0].click
        expect(guest.followings.count).to eq 1
      end

      context "フォローしている状態" do
        before do
          all(:css, ".follow-test")[0].find_all("a")[0].click
          visit customer_path(customer)
        end
        it "フォロー外すリンクが表示される" do
          link = all(:css, ".follow-test")[0].find_all("a")[0].native.text
          expect(link).to match(/フォロー外す/)
        end
        it "フォローが外せる" do
        all(:css, ".follow-test")[0].find_all("a")[0].click
        expect(guest.followings.count).to eq 0
        end
      end

      context "フォローされている状態" do
        let!(:relationship) { create(:relationship,follower_id: customer.id, followed_id: guest.id) }
        it "チャットを始めるボタンは最初は表示されない" do
          expect(all(:css, ".dm-test")[0]).to eq nil
        end
        it "フォローするを押すとチャットを始めるボタンが表示される" do
          all(:css, ".follow-test")[0].find_all("a")[0].click
          btn = all(:css, ".dm-test")[0].find_all('input')[0].native.values[2]
          expect(btn).to match(/チャットを始める/)
        end
        context "相互フォロー状態" do
          before do
            all(:css, ".follow-test")[0].find_all("a")[0].click
          end
          it "チャットを始めるボタンが表示される" do
            btn = all(:css, ".dm-test")[0].find_all('input')[0].native.values[2]
            expect(btn).to match(/チャットを始める/)
          end
          it "チャットを始めるボタンの内容が正しい" do
            all(:css, ".dm-test")[0].find_all("input")[0].click
            expect(current_path).to eq(room_path(Room.last.id))
          end
          context "Roomが存在している場合" do
            before do
              all(:css, ".dm-test")[0].find_all("input")[0].click
              visit customer_path(customer)
            end
            it "チャットへリンクが表示される" do
              link = all(:css, ".dm-test")[0].find_all("a")[0].native.text
              expect(link).to match(/チャットへ/)
            end
            it "チャットへリンクの内容が正しい" do
              all(:css, ".dm-test")[0].find_all("a")[0].click
              expect(current_path).to eq(room_path(Room.last.id))
            end
          end
        end
      end

      it '編集するリンクが表示されない' do
        expect(all(:css, ".customer-edit-btn-test")[0]).to eq nil
      end
      it "編集する画面に遷移できない" do
        visit edit_customer_path(customer)
        expect(current_path).to eq (customer_path(guest))
        expect(page).to have_content('違う会員のプロフィール編集画面へ遷移できません')
      end
      it 'お気に入りグループリンクが表示される' do
        group_favorite_btn = all(:css, ".group-btn-test")[0].find_all("a")[0].native.text
        expect(group_favorite_btn).to match(/お気に入りグループ/)
      end
      it 'お気に入りグループリンクの内容が正しい' do
        all(:css, ".group-btn-test")[0].find_all("a")[0].click
        expect(current_path).to eq (customer_group_favorites_path(customer))
      end
      it '作成したグループリンクが表示される' do
        group_index_btn = all(:css, ".group-btn-test")[0].find_all("a")[1].native.text
        expect(group_index_btn).to match(/作成したグループ/)
      end
      it '作成したグループリンクの内容が正しい' do
        all(:css, ".group-btn-test")[0].find_all("a")[1].click
        expect(current_path).to eq (customer_groups_path(customer))
      end
      it 'いいね一覧リンクが表示される' do
        favorite_index_btn = all(:css, ".index-btn-test")[0].find_all("a")[0].native.text
        expect(favorite_index_btn).to match(/いいね一覧/)
      end
      it 'いいね一覧リンクの内容が正しい' do
        all(:css, ".index-btn-test")[0].find_all("a")[0].click
        expect(current_path).to eq (customer_post_favorites_path(customer))
      end
      it 'コメント一覧リンクが表示される' do
        comment_index_btn = all(:css, ".index-btn-test")[0].find_all("a")[1].native.text
        expect(comment_index_btn).to match(/コメント一覧/)
      end
      it 'コメント一覧へリンクの内容が正しい' do
        all(:css, ".index-btn-test")[0].find_all("a")[1].click
        expect(current_path).to eq (customer_post_comments_path(customer))
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
          visit customer_path(customer)
        end
        it '会員リンクが表示される' do
          profile_image = all(:css, ".customer-profile-test")[1].native.text
          expect(profile_image).to match(/#{customer.name}/)
        end
        it '会員リンクの内容が正しい' do
          all(:css, ".customer-profile-test")[1].click
          expect(current_path).to eq (customer_path(customer))
        end
        it '投稿の表示が正しい' do
          expect(all(:css, ".post-test")[0].text).to match(/#{posts.last.post}/)
        end
        it 'タグリンクが表示される' do
          tag_btn = all(:css, ".tag-test")[0].native.inner_text
          expect(tag_btn).to match(/#{tag_post.name}/)
        end
        it 'タグリンクの内容が正しい' do
          all(:css, ".tag-test")[0].click
          expect(current_path).to eq (tag_search_path)
        end
        it 'タグリンクで遷移した先で検索がかかっている' do
          all(:css, ".tag-test")[0].click
          expect(page).to have_content("タグ(#{tag_post.name})で検索中")
        end
        it '♥リンクが表示される' do
          link = all(:css, ".favorite-test")[0].native.children[1].text
          expect(link).to match(/♥/)
        end
        it '♥リンクをクリックする前のクラス' do
          expect(all(:css, ".favorite-test")[0].native.children[1].attributes['class'].value).to eq ("favorite-black")
        end
        it '♥リンクをクリックした後のクラス非同期', js: true do
          link = all(:css, ".favorite-test")[0].native.find_element(:css, ".favorite-black")
          link.send_keys :tab
          link.click
          sleep 0.5
          expect(all(:css, ".favorite-test")[0].native.find_element(:css, ".favorite-red").attribute("class")).to eq "favorite-red"
        end
        it '♥リンクの内容が正しい', js: true do
          expect(guest.post_favorites.count).to eq 0
          link = all(:css, ".favorite-test")[0].native.find_element(:css, ".favorite-black")
          link.send_keys :tab
          link.click
          sleep 0.5
          expect(guest.post_favorites.count).to eq 1
        end
        it 'いいねリンクが表示される' do
          link = all(:css, ".favorite-test")[0].find_all("a")[1].native.text
          expect(link).to match(/0いいね/)
        end
        it 'いいねリンクの内容が正しい' do
          all(:css, ".favorite-test")[0].find_all("a")[1].click
          expect(current_path).to eq (post_post_favorites_path(posts.last))
        end
        it 'いいねの数が切り替わる', js: true do
          link = all(:css, ".favorite-test")[0].native.find_element(:css, ".favorite-black")
          link.send_keys :tab
          link.click
          sleep 0.5
          expect(all(:css, ".favorite-test")[0].find_all("a")[1].native.text).to match(/1いいね/)
        end
        context 'コメント関連' do
          let!(:post_comment) { create(:post_comment, customer_id: guest.id, post_id: posts.last.id) }
          it 'コメントリンクが表示される' do
            link = all(:css, ".comment-test")[0].native.text
            expect(link).to match(/0コメント/)
          end
          it 'コメントリンクの内容が正しい' do
            all(:css, ".comment-test")[0].click
            expect(current_path).to eq (post_path(posts.last))
          end
          it 'コメントの数が切り替わる' do
            expect(all(:css, ".comment-test")[0].native.text).to match(/0コメント/)
            visit customer_path(customer)
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