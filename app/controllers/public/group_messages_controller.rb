class Public::GroupMessagesController < Public::ApplicationController
  before_action :authenticate_customer!

  ## メッセージ作成
  def create
    ## パラメータの取得
    message = GroupMessage.new(group_message_params)
    message.customer_id = current_customer.id
    # 保存
    if message.save
      # グループの取得
      group = Group.find(params[:group_message][:group_id])
      # 更新するためにタッチする
      group.touch
      # 更新する
      group.save
    end
    redirect_to request.referer
  end

  # パラメーターの許可
  private

  def group_message_params
    params.require(:group_message).permit(:message,:group_id)
  end
end
