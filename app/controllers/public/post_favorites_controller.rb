class Public::PostFavoritesController < Public::ApplicationController
  before_action :authenticate_customer!

  ## 投稿ごとのいいね一覧
  def index
    # 投稿を取得
    @post = Post.find(params[:post_id])
    # 取得した投稿のいいねを新しい順でページごとに取得
    @favorites = @post.post_favorites.latest.page(params[:page])
    # 取得したいいねを配列にし、関連のある全会員を取得
    @customers = Customer.find(@favorites.pluck(:customer_id))
  end

  ## 会員ごとのいいね一覧
  def index_customer
    # 会員を取得
    @customer = Customer.find(params[:customer_id])
    # 取得した会員のいいねを新しい順でページごとに取得
    @favorites = @customer.post_favorites.latest.page(params[:page])
    # 取得したいいねを配列にし、関連のある全投稿を取得
    @posts = Post.find(@favorites.pluck(:post_id))
  end

  ## いいね削除
  def destroy
    # 投稿データの取得
    @post = Post.find(params[:post_id])
    # 投稿に対しての自分のいいねを取得
    if post_favorite = current_customer.post_favorites.find_by(post_id: @post.id)
      # いいねを削除
      post_favorite.destroy
    end
    # 前のページへ
    redirect_to request.referer, notice: "いいねを削除しました"
  end

  ## いいね作成
  def create
    # 投稿データの取得
    @post = Post.find(params[:post_id])
    # customer_idを渡しつつインスタンス作成
    post_favorite = current_customer.post_favorites.new(post_id: @post.id)
    # いいねを保存
    post_favorite.save
    # 前のページへ
    redirect_to request.referer, notice: "いいねを作成しました"
  end

end
