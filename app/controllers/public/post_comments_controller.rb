class Public::PostCommentsController < Public::ApplicationController
  before_action :authenticate_customer!

  # ログインしてるアカウントと同じアカウントかどうかの確認
  before_action :correct_customer, only: [:destroy]
  before_action :correct_customer2, only: [:destroy_all]

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
    # 全コメントを取得
    @comments = @customer.post_comments
    # 取得したコメントを削除
    @comments.destroy_all
    # コメント一覧へ
    redirect_to customer_post_comments_path(@customer),notice: "投稿情報をすべて削除しました"
  end

  ## コメント作成
  def create
    # 投稿を取得
    post = Post.find(params[:post_id])
    # コメントインスタンスを作成しcustomer_idを渡して、パラメータの受け取り
    post_comment = current_customer.post_comments.new(post_comment_params)
    # コメントインスタンスにpost_idを渡す
    post_comment.post_id = post.id
    # コメントを保存
    if post_comment.save
      # 前のページへ
      redirect_to request.referer,notice: "コメントをしました"
    else
      # 前のページへ
      redirect_to request.referer,alert: "コメント数は2~200文字までです"
    end
  end


  # パラメーターの許可
  # ログインしてるアカウントと同じアカウントかどうかの確認
  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)

  end

  def correct_customer
    @post_comment = PostComment.find(params[:id])
    unless @post_comment.customer == current_customer
      redirect_to customer_path(current_customer), notice: '違う会員のコメントは削除できません'
    end
  end

  def correct_customer2
    @customer = Customer.find(params[:customer_id])
    unless @customer == current_customer
      redirect_to customer_path(current_customer), notice: '違う会員のコメントは削除できません'
    end
  end

end
