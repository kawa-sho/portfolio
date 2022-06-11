class Public::RoomsController < Public::ApplicationController
  before_action :authenticate_customer!

  ## ルーム一覧
  def index
    # 会員の取得
    @customer = current_customer
    # 自分のエントリーを取得しルームIDを配列化
    entrys = Entry.where(customer_id: @customer.id).pluck(:room_id)
    # るーむIDで未読のメッセージを新着順に取得
    @rooms = Room.where(id: entrys).latest.page(params[:page])
  end

  ## ルーム作成
  def create
    # ルーム作成
    room = Room.create
    #entryに作ったroom_idと自分のcustomer_idを渡して作る
    Entry.create(:room_id => room.id, :customer_id => current_customer.id)
    #entryにURLからの情報を含み相手のエントリー情報を作る
    Entry.create(:room_id => room.id, :customer_id => params[:entry][:customer_id])
    #部屋に飛ぶ
    redirect_to room_path(room.id)
  end

  ## ルーム詳細
  def show
    # ルームを取得
    @room = Room.find(params[:id])
    #取得したルームの情報の中に自分のidが存在するかどうか
    if Entry.where(:customer_id => current_customer.id, :room_id => @room.id).present?
      # ルームのメッセージを取得
      messages = @room.messages
      # 取得したメッセージを既読にする
      messages.where.not(customer_id: current_customer.id).update(is_active: false)
      #やり取りしたメッセージの抽出
      @messages = @room.messages.last(10)
      #新しいメッセージの作成
      @message = Message.new
      #roomにいるユーザの抽出
      @entries = @room.entries
    else
    #直前のサイトに戻る、戻れなければroot_pathに飛ぶ
    redirect_back(fallback_location: root_path)
    end
  end

  ## ログ一覧
  def index_all
    # ルームを取得
    @room = Room.find(params[:room_id])
    #取得したルームの情報の中に自分のidが存在するかどうか
    if Entry.where(:customer_id => current_customer.id, :room_id => @room.id).present?
      @messages = @room.messages.page(params[:page])
      #roomにいるユーザの抽出
      @entries = @room.entries
    else
    #直前のサイトに戻る、戻れなければroot_pathに飛ぶ
    redirect_back(fallback_location: root_path)
    end
  end

  ## パラメーターの許可
  private

  def entry_params
    params.require(:entry).permit(:customer_id, :room_id)
  end

end
