class Admin::PostFavoritesController < Admin::ApplicationController
  before_action :authenticate_admin!

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

end
