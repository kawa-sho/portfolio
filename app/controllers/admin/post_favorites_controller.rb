class Admin::PostFavoritesController < Admin::ApplicationController
  before_action :authenticate_admin!

   # 投稿ごとのいいね一覧
  def index
    @post = Post.find(params[:post_id])
    @favorites = @post.post_favorites.latest.page(params[:page])
    @customers = Customer.find(@favorites.pluck(:customer_id))
  end

  # 会員ごとのいいね一覧
  def index_customer
    @customer = Customer.find(params[:customer_id])
    @favorites = @customer.post_favorites.latest.page(params[:page])
    @posts = Post.find(@favorites.pluck(:post_id))
  end

end
