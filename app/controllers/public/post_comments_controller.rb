class Public::PostCommentsController < Public::ApplicationController

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

  def create
    # 一つの投稿データ
    @post = Post.find(params[:post_id])
    # コメントcustomer_idを渡して、パラメータの受け取り
    comment = current_customer.post_comments.new(post_comment_params)
    comment.post_id = @post.id
    comment.save
    redirect_to request.referer,notice: "コメントをしました"
  end


  # パラメーターの許可
  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)

  end

end
