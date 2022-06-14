class Admin::GroupFavoritesController < Admin::ApplicationController
  before_action :authenticate_admin!

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

end
