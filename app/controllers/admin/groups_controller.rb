class Admin::GroupsController < Admin::ApplicationController
  before_action :authenticate_admin!

  ## グループ一覧
  def index
    # 全グループを更新順で取得
    @groups = Group.latest.page(params[:page])
    # タグを紐づいているグループが多い順に２０個取得
    @tags=TagGroup.group_count.first(20)
  end

  ## グループ一覧
  def index_customer
    # 全グループを更新順で取得
    @groups = Group.latest.where(customer_id: params[:customer_id]).page(params[:page])
  end

  ## グループ詳細
  def show
    # グループの取得
    @group = Group.find(params[:id])
    # 取得したグループに対してのタグを取得
    @group_tags = @group.tag_groups
    # 会員の取得
    @customers = Customer.where(id: @group.customer_id)
  end

  ## グループ削除
  def destroy
    # グループの取得
    @group = Group.find(params[:id])
    # グループの削除
    @group.delete
    # タグに紐づいているグループがなくなっていた場合タグの削除メソッド
    Group.tag_delete
    # グループ一覧へ
    redirect_to admin_groups_path,alert: "グループ情報を削除しました"
  end

  ## グループチャット部屋
  def room
    # グループの取得
    @group = Group.find(params[:group_id])
    # メッセージの取得
    @messages = @group.group_messages.last(10)
  end

  ## グループチャット部屋(ログ)
  def room_log
    # グループの取得
    @group = Group.find(params[:group_id])
    # メッセージの取得
    @messages = @group.group_messages.page(params[:page])
    # メッセージのインスタンス作成
    @message = GroupMessage.new
  end

  ## グループ検索
  def search
    # 送られてきた値でsearchメソッドで検索しページごとに取得
    @groups = Group.latest.search(params[:keyword]).page(params[:page])
    # viewに何を検索しているのかを表示するため送られてきた値を取得
    @keyword = params[:keyword]
    # タグを紐づいているグループが多い順に２０個取得
    @tags = TagGroup.group_count.first(20)
    # 会員一覧へ
    render :index
  end

  ## タグ検索
  def tag_search
    # タグを紐づいているグループが多い順に２０個取得
    @tags = TagGroup.group_count.first(20)
    # 検索されたタグを受け取る
    tag = TagGroup.find(params[:tag_group_id])
    # 検索されたタグに紐づくグループを表示
    @groups = tag.groups.page(params[:page])
    # viewに何を検索しているのかを表示するため送られてきた値を取得
    @tag_keyword = tag.name
    # 会員一覧へ
    render :index
  end

end
