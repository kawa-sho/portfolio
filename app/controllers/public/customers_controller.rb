class Public::CustomersController < Public::ApplicationController
  # ログインしてるアカウントと同じアカウントかどうかの確認とゲストログインかどうかの確認
  before_action :correct_customer, only: [:edit, :update]
  before_action :correct_customer2, only: [:quit_check, :withdraw]

  ## 会員一覧
  def index
    #全会員を取得
    @customers = Customer.page(params[:page])
    #ページを取得
    @page = params[:page]
  end

  ## 会員詳細
  def show
    # 会員を取得
    @customer = Customer.find(params[:id])
    # 取得した会員の投稿を新しい順にページごとに取得
    @posts = @customer.posts.latest.page(params[:page])
    @page = params[:page]
    # 新着メッセージがあるかないか
    # 会員の取得
    customer = current_customer
    # 自分のエントリーを取得しルームIDを配列化
    entrys = Entry.where(customer_id: customer.id).pluck(:room_id)
    # るーむIDで未読のメッセージを新着順に取得
    @messages = Message.where(room_id: entrys, is_active: true).where.not(customer_id: @customer.id)

    ## DM機能の作成
    # 自分のエントリー情報を抽出
    current_customer_entry = Entry.where(customer_id: current_customer.id)
    # 取得した会員のエントリー情報を抽出
    customer_entry = Entry.where(customer_id: @customer.id)
    # 見てるページのユーザーと自分のユーザーがおんなじかどうか
    unless @customer == current_customer
    # 自分の持ってるエントリー情報と見てるページのユーザーのエントリー情報をすべて抽出する
      current_customer_entry.each do |cce|
        customer_entry.each do |ce|
    # 自分の持ってるroom_idと見てるページのユーザーの持ってるroom_idの中に同じroom_idがあるかどうか
          if cce.room_id == ce.room_id
    # roomはあるよと定義しroom_idをインスタンス変数で渡す
            @isRoom = true
            @roomId = cce.room_id
          end
        end
      end
    # roomがない場合
      unless @isRoom
    # 新しいインスタンスを制作する
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  ## 会員編集
  def edit
  end

  ## 会員更新
  def update
    # 受け取ったデータで更新
    if @customer.update(customer_params)
      # 会員詳細へ
      redirect_to customer_path(current_customer), notice: "会員情報を更新しました"
    else
      # 会員編集へ
      render :edit
    end
  end

  ##  退会ページ
  def quit_check
  end

  ##  退会にステータスを更新
  def withdraw
    # 会員を退会させる
    if @customer.update(is_active: false)
      # ログアウトさせる
      reset_session
      # トップへ
      redirect_to root_path, notice: "退会しました"
    else
      # 退会ページへ
      render "quit_check"
    end
  end

  ## 会員検索
  def search
    # 送られてきた値でsearchメソッドで検索しページごとに取得
    @customers = Customer.search(params[:keyword]).page(params[:page])
    # viewに何を検索しているのかを表示するため送られてきた値を取得
    @keyword = params[:keyword]
    # 会員一覧へ
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
