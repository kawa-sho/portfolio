class Public::PostCommentsController < Public::ApplicationController
  before_action :authenticate_customer!

  # ログインしてるアカウントと同じアカウントかどうかの確認
  before_action :correct_customer, only: [:destroy]
  before_action :correct_customer2, only: [:destroy_all]

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
    @comments = @customer.post_comments
    @comments.destroy_all
    redirect_to customer_post_comments_path(@customer),notice: "投稿情報をすべて削除しました"
  end

  def create
    # 一つの投稿データ
    @post = Post.find(params[:post_id])
    # コメントcustomer_idを渡して、パラメータの受け取り
    @post_comment = current_customer.post_comments.new(post_comment_params)
    @post_comment.post_id = @post.id
    if @post_comment.save
      redirect_to request.referer,notice: "コメントをしました"
    else
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
