class Admin::PostCommentsController < Admin::ApplicationController
  before_action :authenticate_admin!

  ## 会員ごとのコメント一覧
  def index
    # 会員を取得
    @customer = Customer.find(params[:customer_id])
    # 取得した会員のコメントを新しい順にページに分けて取得
    @comments = @customer.post_comments.latest.page(params[:page])
  end

  ## コメント削除
  def destroy
    # コメントを取得し削除
    PostComment.find(params[:id]).destroy
    # ページを戻す
    redirect_to request.referer,notice: "コメントを削除しました"
  end

  ## コメント全削除
  def destroy_all
    # 会員を取得
    customer = Customer.find(params[:customer_id])
    # 取得した会員の全コメントを取得
    comments = customer.post_comments
    # 取得したコメントを削除
    comments.destroy_all
    # コメント一覧へ
    redirect_to admin_customer_post_comments_path(customer),notice: "投稿情報をすべて削除しました"
  end

end
