class Admin::PostCommentsController < Admin::ApplicationController
  before_action :authenticate_admin!

  # 会員ごとのコメント一覧
  def index
    @customer = Customer.find(params[:customer_id])
    @comments = @customer.post_comments.latest.page(params[:page])
  end

  def destroy
    # コメントの削除
    PostComment.find(params[:id]).destroy
    redirect_to request.referer,notice: "コメントを削除しました"
  end

  def destroy_all
    #　コメント全削除
    @customer = Customer.find(params[:customer_id])
    @comments = @customer.post_comments
    @comments.destroy_all
    redirect_to customer_post_comments_path(@customer),notice: "投稿情報をすべて削除しました"
  end
end
