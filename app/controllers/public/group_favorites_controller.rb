class Public::GroupFavoritesController < Public::ApplicationController
  before_action :authenticate_customer!

  ## グループごとのお気に入り一覧
  def index
    # グループを取得
    @group = Group.find(params[:group_id])
    # 取得したグループのお気に入りを新しい順でページごとに取得
    @favorites = @group.group_favorites.latest.page(params[:page])
    # 取得したお気に入りを配列にし、関連のある全会員を取得
    @customers = Customer.find(@favorites.pluck(:customer_id))
  end

  ## 会員ごとのお気に入り一覧
  def index_customer
    # 会員を取得
    @customer = Customer.find(params[:customer_id])
    # 取得した会員のお気に入りを新しい順でページごとに取得
    @favorites = @customer.group_favorites.latest.page(params[:page])
    # 取得したお気に入りを配列にし、関連のある全グループを取得
    @groups = Group.find(@favorites.pluck(:group_id))
  end

  ## お気に入り削除
  def destroy
    # グループデータの取得
    @group = Group.find(params[:group_id])
    # グループに対しての自分のお気に入りを取得
    if group_favorite = current_customer.group_favorites.find_by(group_id: @group.id)
      # お気に入りを削除
      group_favorite.destroy
    end
    # 前のページへ
    redirect_to request.referer, notice: "お気に入りを削除しました"
  end

  ## お気に入り作成
  def create
    # グループデータの取得
    @group = Group.find(params[:group_id])
    # customer_idを渡しつつインスタンス作成
    group_favorite = current_customer.group_favorites.new(group_id: @group.id)
    # お気に入りを保存
    group_favorite.save
    # 前のページへ
    redirect_to request.referer, notice: "お気に入りを作成しました"
  end

end
