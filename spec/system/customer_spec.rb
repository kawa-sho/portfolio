require 'rails_helper'

describe '会員詳細画面のテスト' do
  let!(:customer) { create(:customer) }
  let!(:customer2) { create(:customer) }

  describe '自分の会員詳細画面' do
    before do
      visit new_customer_session_path
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'ログイン'
      visit customer_path(customer)
    end

    describe '会員詳細の表示内容と遷移先確認' do
      it 'URLが正しい' do
        expect(current_path).to eq (customer_path(customer))
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
      it 'フォロー数リンクが表示される: 左上から6番目のリンクが「フォロー数」である' do
        follow_index_btn = all(:css, ".follow-index-btn-test")[0].find_all("a")[0].native.text
        expect(follow_index_btn).to match(/フォロー数: #{customer.followings.count}/)
      end
      it 'フォロー数リンクの内容が正しい' do
        all(:css, ".follow-index-btn-test")[0].find_all("a")[0].click
        expect(current_path).to eq (customer_followings_path(customer))
      end
      it 'フォロー数が増える' do
        expect { create(:relationship,follower_id: customer.id, followed_id: customer2.id) }.to change{customer.followings.count}.by(1)
      end
      it 'フォロワー数リンクが表示される: 左上から7番目のリンクが「フォロワー数」である' do
        link = find_all('a')[7].native.inner_text
        expect(link).to match(/フォロワー数: #{customer.followers.count}/)
      end
      it 'フォロワー数リンクの内容が正しい' do
        find_all('a')[7].click
        expect(current_path).to eq (customer_followers_path(customer))
      end
      # it 'フォロワー数が増える' do
      #   expect { create(:relationship,follower_id: customer2.id, followed_id: customer.id) }.to change{customer.followers.count}.by(1)
      # end
      # it '編集するリンクが表示される: 左上から8番目のリンクが「編集する」である' do
      #   link = find_all('a')[8].native.inner_text
      #   expect(link).to match(/編集する/)
      # end
      # it '編集するリンクの内容が正しい' do
      #   find_all('a')[8].click
      #   expect(current_path).to eq (edit_customer_path(customer))
      # end
      # it '新着メッセージへリンクが表示される: 左上から9番目のリンクが「新着メッセージへ」である' do
      #   link = find_all('a')[9].native.inner_text
      #   expect(link).to match(/新着メッセージへ/)
      # end
      # it '新着メッセージへリンクの内容が正しい' do
      #   find_all('a')[9].click
      #   expect(current_path).to eq (messages_path)
      # end
      # it '新着メッセージがない場合のクラス' do
      #   expect(find_all('a')[9].native.attributes['class'].value).to eq ("btn btn-primary")
      # end
      # it '新着メッセージがある場合のクラス' do
      #   room = create(:room)
      #   create(:entry,customer_id: customer.id, room_id: room.id)
      #   create(:entry,customer_id: customer2.id, room_id: room.id)
      #   create(:message,room_id: room.id,customer_id: customer2.id)
      #   create(:relationship,follower_id: customer2.id, followed_id: customer.id)
      #   visit customer_path(customer)
      #   expect(find_all('a')[9].native.attributes['class'].value).to eq ("btn btn-danger")
      # end
      # it 'DMルーム一覧へリンクが表示される: 左上から10番目のリンクが「DMルーム一覧へ」である' do
      #   link = find_all('a')[10].native.inner_text
      #   expect(link).to match(/DMルーム一覧へ/)
      # end
      # it 'DMルーム一覧へリンクの内容が正しい' do
      #   find_all('a')[10].click
      #   expect(current_path).to eq (rooms_path)
      # end
      # it 'お気に入りグループリンクが表示される: 左上から11番目のリンクが「お気に入りグループ」である' do
      #   link = find_all('a')[11].native.inner_text
      #   expect(link).to match(/お気に入りグループ/)
      # end
      # it 'お気に入りグループリンクの内容が正しい' do
      #   find_all('a')[11].click
      #   expect(current_path).to eq (customer_group_favorites_path(customer))
      # end
      # it '作成したグループリンクが表示される: 左上から12番目のリンクが「作成したグループ」である' do
      #   link = find_all('a')[12].native.inner_text
      #   expect(link).to match(/作成したグループ/)
      # end
      # it '作成したグループリンクの内容が正しい' do
      #   find_all('a')[12].click
      #   expect(current_path).to eq (customer_groups_path(customer))
      # end
      # it 'いいね一覧リンクが表示される: 左上から13番目のリンクが「いいね一覧」である' do
      #   link = find_all('a')[13].native.inner_text
      #   expect(link).to match(/いいね一覧/)
      # end
      # it 'いいね一覧リンクの内容が正しい' do
      #   find_all('a')[13].click
      #   expect(current_path).to eq (customer_post_favorites_path(customer))
      # end
      # it 'コメント一覧リンクが表示される: 左上から14番目のリンクが「コメント一覧」である' do
      #   link = find_by_id("comment_index_page").native.inner_text
      #   expect(link).to match(/コメント一覧/)
      # end
      # it 'コメント一覧へリンクの内容が正しい' do
      #   find_by_id("comment_index_page").click
      #   expect(current_path).to eq (customer_post_comments_path(customer))
      # end
    end


    # describe '会員詳細ページの投稿一覧の表示内容と遷移先確認' do
    #   context '投稿が存在しないとき' do
    #     it '見出しの確認' do
    #       expect(find_all('h3')[0].native.text).to match(/#{customer.name}の投稿一覧/)
    #     end
    #     it '投稿が存在しない場合の表示' do
    #       expect(page).to have_content(/#{customer.name}の投稿が存在しません/)
    #     end
    #   end

    #   context '投稿が存在する場合' do
    #     let!(:posts) { create_list(:post,21,customer_id: customer.id) }
    #     let!(:tag_post) { create(:tag_post) }
    #     let!(:post_tag_post) { create(:post_tag_post,post_id: posts.last.id, tag_post_id: tag_post.id) }
    #     before do
    #       visit customer_path(customer)
    #     end
    #     it '会員リンクが表示される: 左上から15番目のリンクが「customer.name」である' do
    #       link = all(:css, ".link-color")[0].native.inner_text
    #       expect(link).to match(/#{customer.name}/)
    #     end
    #     it '会員リンクの内容が正しい' do
    #       all(:css, ".link-color")[0].click
    #       expect(current_path).to eq (customer_path(customer))
    #     end
    #     it 'タグリンクが表示される: 左上から16番目のリンクが「tag_post.name」である' do
    #       link = all(:css, ".tag-test")[0].native.inner_text
    #       expect(link).to match(/#{tag_post.name}/)
    #     end
    #     it 'タグリンクの内容が正しい' do
    #       all(:css, ".tag-test")[0].click
    #       expect(current_path).to eq (tag_search_path)
    #     end
    #     it 'タグリンクで遷移した先で検索がかかっている' do
    #       all(:css, ".tag-test")[0].click
    #       expect(page).to have_content("タグ(#{tag_post.name})で検索中")
    #     end
    #     it '♥リンクが表示される: 左上から17番目のリンクが「♥」である' do
    #       link = all(:css, ".favorite-test")[0].native.children[1].text
    #       expect(link).to match(/♥/)
    #     end
    #     it '♥リンクをクリックする前のクラス' do
    #       expect(all(:css, ".favorite-test")[0].native.children[1].attributes['class'].value).to eq ("favorite-black")
    #     end
    #     it '♥リンクをクリックした後のクラス非同期', js: true do
    #       link = all(:css, ".favorite-test")[0].native.find_element(:css, ".favorite-black")
    #       link.send_keys :tab
    #       link.click
    #       sleep 0.5
    #       expect(all(:css, ".favorite-test")[0].native.find_element(:css, ".favorite-red").attribute("class")).to eq "favorite-red"
    #     end
    #     it '♥リンクの内容が正しい', js: true do
    #       expect(customer.post_favorites.count).to eq 0
    #       link = all(:css, ".favorite-test")[0].native.find_element(:css, ".favorite-black")
    #       link.send_keys :tab
    #       link.click
    #       sleep 0.5
    #       expect(customer.post_favorites.count).to eq 1
    #     end
    #   end
    # end
  end

end


#<Capybara::Node::Element tag="a" path="/HTML/BODY[1]/MEIN[1]/DIV[3]/TABLE[1]/TBODY[1]/TR[4]/TD[1]/DIV[1]/A[1]">  js:true
#<Capybara::Node::Element tag="a" path="/html/body/mein/div[3]/table[1]/tbody/tr[4]/td/div/a[1]">

# faind_by_id()
# all(:css, ".text-right")[5].native.children[1].children[1].attributes["class"].value
# all(:css, ".text-right")[5].native.find_element(:css, ".favorite-black").attribute("class")