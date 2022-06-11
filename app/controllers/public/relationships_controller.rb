class Public::RelationshipsController < Public::ApplicationController
  before_action :authenticate_customer!

  ## フォローするとき
  def create
    # フォローする
    current_customer.follow(params[:customer_id])
    # 前のページへ
    redirect_to request.referer
  end

  ## フォロー外すとき
  def destroy
    # フォローを外す
    current_customer.unfollow(params[:customer_id])
    # 前のページへ
    redirect_to request.referer
  end

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
