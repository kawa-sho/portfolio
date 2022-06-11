class Public::MessagesController < Public::ApplicationController
  before_action :authenticate_customer!

  ## 新着メッセージ一覧
  def index
    # 会員の取得
    @customer = current_customer
    # 自分のエントリーを取得しルームIDを配列化
    entrys = Entry.where(customer_id: @customer.id).pluck(:room_id)
    # るーむIDで未読のメッセージを新着順に取得
    @messages = Message.where(room_id: entrys, is_active: true).where.not(customer_id: @customer.id).latest.page(params[:page])
  end

  ## メッセージ作成
  def create
    #紐づきの確認
    #entryのどこかに自分のidが存在しかつ:messageと:room_idのキーがちゃんと入っているか
    if Entry.where(:customer_id => current_customer.id, :room_id => params[:message][:room_id]).present?
      # メッセージを作成
      @message = Message.create(message_params.merge(:customer_id => current_customer.id))
      # ルームの更新時間を更新
      room = Room.find(params[:message][:room_id])
      # 更新するためにタッチする
      room.touch
      # 更新する
      room.save
    end
     redirect_to request.referer
  end

# 　パラメーターの許可
  private

  def message_params
    params.require(:message).permit(:customer_id, :message, :room_id)
  end
end
