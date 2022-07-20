class Public::GroupsController < Public::ApplicationController
  # グループを作った人しか編集できないように
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  ## グループ一覧
  def index
    # 全グループを更新順で取得
    @groups = Group.latest.page(params[:page])
    # タグを紐づいているグループが多い順に２０個取得
    @tags=TagGroup.group_count.first(20)
  end

  ## 会員ごとのグループ一覧
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

  ## 新規グループ
  def new
    @tag_lists = []
    # グループインスタンスの作成
    @group = Group.new
  end

  ## グループ作成
  def create
    # パラメーターの取得
    @group = Group.new(group_params)
    # オーナーにする
    @group.customer_id = current_customer.id
    # 受け取った値を,で区切って配列にし、uniqで同じものを一つにする
    @tag_lists=params[:group][:tag_name].delete(' ').delete('　').split(',').uniq
    # グループの保存
    if @group.save
      # 10文字以上のものはアラートを出す
      flash[:alert] = 'タグが10文字以上のものは削除しました' if @tag_lists.any? { |tag| tag.length >= 10 }
      # save_tag_groupはモデルにメソッド
      @group.save_tag_group(@tag_lists)
      # メソッドの運用
      TagGroup.tag_delete
      # グループ詳細へ
      redirect_to group_path(@group),notice: "グループを作成しました"
    else
      flash[:alert] = ""
      # 新規グループ作成へ
      render :new
    end
  end

  ## グループ編集
  def edit
    # グループを取得
    @group = Group.find(params[:id])
    # フォームに入れるため
    @tag_lists= @group.tag_groups.pluck(:name)
  end

  ## グループ更新
  def update
    # 受け取った値を,で区切って配列にし、uniqで同じものを一つにする
    @tag_lists=params[:group][:tag_name].delete(' ').delete('　').split(',').uniq
    # グループの更新
    if @group.update(group_params)
      # グループに紐づいているすべてのタグを削除
      @group.tag_groups.destroy_all
      # 10文字以上のものはアラートを出す
      flash[:alert] = "タグが１０文字以上のものは削除しました" if @tag_lists.any? { |tag| tag.length >= 10 }
      # save_tag_groupはモデルにメソッド
      @group.save_tag_group(@tag_lists)
      # メソッドの運用
      TagGroup.tag_delete
      # グループ詳細へ
      redirect_to group_path(@group),notice: "投稿情報を更新しました"
    else
      flash[:alert] = ""
      # 投稿編集へ
      render :edit
    end
  end

  ## グループ削除
  def destroy
    # グループの削除
    @group.destroy
    # タグに紐づいているグループがなくなっていた場合タグの削除メソッド
    TagGroup.tag_delete
    # グループ一覧へ
    redirect_to groups_path,alert: "グループ情報を削除しました"
  end

  ## グループチャット部屋
  def room
    # グループの取得
    @group = Group.find(params[:group_id])
    # メッセージの取得
    @messages = @group.group_messages.last(10)
    # メッセージのインスタンス作成
    @message = GroupMessage.new
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

  # パラメーターの許可
  # オーナーかどうかの確認
  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.customer_id == current_customer.id
      redirect_to groups_path, notice: 'オーナーでないと編集できません'
    end
  end

end
