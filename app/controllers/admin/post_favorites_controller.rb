class Admin::PostFavoritesController < Admin::ApplicationController
  before_action :authenticate_admin!

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

end
