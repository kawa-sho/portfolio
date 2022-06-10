class Admin::CustomersController < Admin::ApplicationController
  before_action :authenticate_admin!

  ## 会員詳細
  def show
    # 会員を取得
    @customer = Customer.find(params[:id])
    # 会員の投稿を新しい順にページごとに取得
    @posts = @customer.posts.latest.page(params[:page])
  end

  ## 会員編集
  def edit
    # 会員を取得
    @customer = Customer.find(params[:id])
  end

  ## 会員更新
  def update
    # 会員を取得
    @customer = Customer.find(params[:id])
    # 受け取ったデータで更新
    if @customer.update(customer_params)
      # 会員詳細へ
      redirect_to admin_customer_path(@customer), notice: "会員情報を更新しました"
    else
      # 会員編集へ
      render :edit
    end
  end


  # 会員パラメーターの許可
  private

  def customer_params
    params.require(:customer).permit(:name,:introduction,:profile_image,:is_active)
  end

end
