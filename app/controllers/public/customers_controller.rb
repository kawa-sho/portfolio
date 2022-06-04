class Public::CustomersController < Public::ApplicationController
  # ログインしてるアカウントと同じアカウントかどうかの確認
  before_action :correct_customer, only: [:edit, :update]
  before_action :correct_customer2, only: [:quit_check, :withdraw]
  # ゲストログインかどうかの確認
  before_action :ensure_guest_customer, only: [:edit]
  before_action :ensure_guest_customer2, only: [:quit_check]

  def index
    #全会員情報
    @customers = Customer.page(params[:page])
  end

  def show
    #そのページの会員情報
    @customer = Customer.find(params[:id])
    #会員の全投稿
    @posts = @customer.posts.page(params[:page])
  end

  def edit
    #そのページの会員情報
    @customer = Customer.find(params[:id])
  end

  def update
    #会員情報の更新
    if @customer.update(customer_params)
      redirect_to customer_path(current_customer), notice: "会員情報更新しました"
    else
      render :edit
    end
  end

  # 退会ページ
  def quit_check
    @customer = current_customer
  end

  # 退会にステータスを更新
  def withdraw
    if @customer.update(is_active: false)
      reset_session
      redirect_to root_path, notice: "退会しました"
    else
      render "quit_check"
    end
  end



  # 会員パラメーターの許可
  # ログインしてるアカウントと同じアカウントかどうかの確認
  # ゲストログインかどうかの確認
  private

  def customer_params
    params.require(:customer).permit(:name,:introduction,:profile_image)
  end

  def correct_customer
    @customer = Customer.find(params[:id])
    unless @customer == current_customer
      redirect_to customer_path(current_user)
    end
  end

  def correct_customer2
    @customer = Customer.find(params[:customer_id])
    unless @customer == current_customer
      redirect_to customer_path(current_user)
    end
  end

  def ensure_guest_customer
    @customer = Customer.find(params[:id])
    if @customer.name == "guestuser"
      redirect_to customer_path(current_customer) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません'
    end
  end

  def ensure_guest_customer2
    @customer = Customer.find(params[:customer_id])
    if @customer.name == "guestuser"
      redirect_to customer_path(current_customer) , notice: 'ゲストユーザーは退会ページへ遷移できません'
    end
  end
end
