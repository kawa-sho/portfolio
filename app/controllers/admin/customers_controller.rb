class Admin::CustomersController < Admin::ApplicationController
  before_action :authenticate_admin!

  def show
    # そのページの会員情報
    @customer = Customer.find(params[:id])
    # その会員の全投稿
    @posts = @customer.posts.page(params[:page])
  end

  def edit
    #そのページの会員情報
    @customer = Customer.find(params[:id])
  end

  def update
    #そのページの会員情報
    @customer = Customer.find(params[:id])
    #会員情報の更新
    if @customer.update(customer_params)
      redirect_to admin_customer_path(@customer), notice: "会員情報を更新しました"
    else
      render :edit
    end
  end

  # 会員パラメーターの許可
  private

  def customer_params
    params.require(:customer).permit(:name,:introduction,:profile_image,:is_active)
  end

end
