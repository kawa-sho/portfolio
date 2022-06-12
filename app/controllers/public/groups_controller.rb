class Public::GroupsController < Public::ApplicationController
  before_action :authenticate_customer!
  # グループを作った人しか編集できないように
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  ## グループ一覧
  def index
    # 全グループを更新順で取得
    @groups = Group.latest.page(params[:page])
  end

  ## グループ詳細
  def show
    # グループの取得
    @group = Group.find(params[:id])
  end

  ## 新規グループ
  def new
    # グループインスタンスの作成
    @group = Group.new
  end

  ## グループ作成
  def create
    # パラメーターの取得
    @group = Group.new(group_params)
    # オーナーにする
    @group.owner_id = current_customer.id
    # グループを保存する
    if @group.save
      # グループ一覧へ
      redirect_to groups_path
    else
      # 新規グループへ
      render 'new'
    end
  end

  ## グループ編集
  def edit
  end

  ## グループ更新
  def update
    # グループのパラメーターを取得し更新
    if @group.update(group_params)
      # グループ一覧へ
      redirect_to groups_path
    else
      # グループ編集へ
      render "edit"
    end
  end

  ## グループ削除
  def destroy
    # グループの削除
    @group.delete
    # グループ一覧へ
    redirect_to groups_path
  end

  ## グループチャット部屋
  def room
    @group = Group.find(params[:group_id])
  end

  # パラメーターの許可
  # オーナーかどうかの確認
  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_customer.id
      redirect_to groups_path
    end
  end

end
