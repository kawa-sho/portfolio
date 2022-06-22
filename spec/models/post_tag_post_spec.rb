require 'rails_helper'

RSpec.describe 'PostTagPostモデルのテスト', type: :model do

  describe 'アソシエーションのテスト' do
    context 'postモデルとの関係' do
      it '1:Nとなっている' do
        expect(PostTagPost.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
    context 'tag_postモデルとの関係' do
      it '1:Nとなっている' do
        expect(PostTagPost.reflect_on_association(:tag_post).macro).to eq :belongs_to
      end
    end
  end


end