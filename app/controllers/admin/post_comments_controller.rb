class Admin::PostCommentsController < Admin::ApplicationController

  ## 会員ごとのコメント一覧
  def index
    # 会員を取得
    @customer = Customer.find(params[:customer_id])
    # 取得した会員のコメントを新しい順にページに分けて取得
    @comments = @customer.post_comments.latest.page(params[:page])
    # コメント一覧かどうかの見極め
    @index = true
  end

  ## コメント削除
  def destroy
    # コメントを取得し削除
    PostComment.find(params[:id]).destroy
    # アラート
    flash.now[:alert] = 'コメントを削除しました'
    # 投稿を取得
    @post = Post.find(params[:post_id])
    # 取得した投稿に対しての全コメントをページごとに取得
    @comments = @post.post_comments.page(params[:page]).per(5)
    # ページの取得
    @page = params[:page]
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
    redirect_to admin_customer_post_comments_path(customer),alert: "投稿情報をすべて削除しました"
  end

end
