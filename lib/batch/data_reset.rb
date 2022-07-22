class Batch::DataReset
  def self.data_reset
    #メソッドの運用
    TagPost.tag_delete
    p "紐づいている投稿が存在しないタグを全て削除しました"
  end
end