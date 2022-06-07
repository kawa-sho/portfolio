class Public::CustomersController < Public::ApplicationController
  before_action :authenticate_customer!
  # ログインしてるアカウントと同じアカウントかどうかの確認とゲストログインかどうかの確認
  before_action :correct_customer, only: [:edit, :update]
  before_action :correct_customer2, only: [:quit_check, :withdraw]


  def index
    #全会員情報
    @customers = Customer.page(params[:page])
  end

  def show
    #そのページの会員情報
    @customer = Customer.find(params[:id])
    #会員の全投稿
    @posts = @customer.posts.latest.page(params[:page])
  end

  def edit
  end

  def update
    #会員情報の更新
    if @customer.update(customer_params)
      redirect_to customer_path(current_customer), notice: "会員情報を更新しました"
    else
      render :edit
    end
  end

  # 退会ページ
  def quit_check
  end

  # 退会にステータスを更新
  def withdraw
    if @customer.update(is_active: false)
      # ログアウトさせる
      reset_session
      redirect_to root_path, notice: "退会しました"
    else
      render "quit_check"
    end
  end

  def search
    # 検索情報抜き出し
    @customers = Customer.search(params[:keyword]).page(params[:page])
    @keyword = params[:keyword]
    render "index"
  end



  # 会員パラメーターの許可
  # ログインしてるアカウントと同じアカウントかどうかの確認とゲストログインかどうかの確認
  private

  def customer_params
    params.require(:customer).permit(:name,:introduction,:profile_image)
  end

  def correct_customer
    @customer = Customer.find(params[:id])
    unless @customer == current_customer
      redirect_to customer_path(current_customer), notice: '違う会員のプロフィール編集画面へ遷移できません'
    end
    if @customer.name == "guestcustomer"
      redirect_to customer_path(current_customer) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません'
    end
  end

  def correct_customer2
    @customer = Customer.find(params[:customer_id])
    unless @customer == current_customer
      redirect_to customer_path(current_customer), notice: '違う会員の退会ページへ遷移できません'
    end
    if @customer.name == "guestcustomer"
      redirect_to customer_path(current_customer) , notice: 'ゲストユーザーは退会ページへ遷移できません'
    end
  end
end
