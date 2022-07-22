class Batch::DataReset
  def self.data_reset
    #メソッドの運用
    TagPost.tag_delete
    TagGroup.tag_delete
    p "紐づいている(投稿,グループ）が存在しないタグを全て削除しました"
  end
end