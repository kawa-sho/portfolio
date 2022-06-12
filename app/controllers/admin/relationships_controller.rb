class Admin::RelationshipsController < Admin::ApplicationController
  before_action :authenticate_admin!
  ## フォロー一覧
  def followings
    # 会員の取得
    @customer = Customer.find(params[:customer_id])
    # 取得した会員のフォロー一覧
    @customers = @customer.followings.page(params[:page])
  end

  ## フォロワー一覧
  def followers
    # 会員の取得
    @customer = Customer.find(params[:customer_id])
    # 取得した会員のフォロワー一覧
    @customers = @customer.followers.page(params[:page])
  end
end
