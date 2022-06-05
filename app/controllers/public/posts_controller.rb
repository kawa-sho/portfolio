class Public::PostsController < Public::ApplicationController
  # ログインしてるアカウントと同じアカウントかどうかの確認
  before_action :correct_customer, only: [:edit, :update]

  def index
    # 全投稿情報
    @posts = Post.page(params[:page])
  end

  def show
    # そのページの投稿
    @post = Post.find(params[:id])
  end

  def edit
    # そのページの投稿情報
    @post = Post.find(params[:id])
  end

  def update
    # 投稿情報の更新
    if @post.update(post_params)
      redirect_to post_path(@post),notice: "投稿情報を更新しました"
    else
      render :edit
    end
  end

  def destroy
    # 投稿情報の削除
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to customer_path(current_customer),notice: "投稿情報を削除しました"
  end

  def destroy_all
    # 投稿情報の全削除
    @posts = current_customer.posts
    @posts.destroy_all
    redirect_to customer_path(current_customer),notice: "投稿情報をすべて削除しました"
  end

  def new
    # 新規投稿
    @post = Post.new
  end

  def create
    # 新規投稿作成
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    if @post.save
      redirect_to post_path(@post),notice: "投稿しました"
    else
      render :new
    end
  end


  # 投稿パラメーターの許可
  # ログインしてるアカウントと同じアカウントかどうかの確認
  private

  def post_params
    params.require(:post).permit(:post)
  end

  def correct_customer
    @post= Post.find(params[:id])
    unless @post.customer == current_customer
      redirect_to post_path(@post)
    end
  end
end
