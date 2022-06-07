class Public::PostFavoritesController < Public::ApplicationController
  before_action :authenticate_customer!

  # 投稿ごとのいいね一覧
  def index
    @post = Post.find(params[:post_id])
    @favorites = @post.post_favorites.latest.page(params[:page])
  end

  # 会員ごとのいいね一覧
  def index_customer
    @customer = Customer.find(params[:customer_id])
    @favorites = @customer.post_favorites.latest.page(params[:page])
  end

  def destroy
    # 投稿データの取得
    @post = Post.find(params[:post_id])
    # 投稿に対しての自分のいいねを取得
    post_favorite = current_customer.post_favorites.find_by(post_id: @post.id)
    post_favorite.destroy
    redirect_to request.referer, notice: "いいねを削除しました"
  end

  def create
    # 投稿データの取得
    @post = Post.find(params[:post_id])
    # customer_idを渡しつつインスタンス作成
    post_favorite = current_customer.post_favorites.new(post_id: @post.id)
    post_favorite.save
    redirect_to request.referer, notice: "いいねを作成しました"
  end

end
