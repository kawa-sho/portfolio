class Admin::PostsController < Admin::ApplicationController
  before_action :authenticate_admin!

  ## 投稿一覧
  def index
    # 投稿を新しい順にページごとに取得
    @posts = Post.latest.page(params[:page])
    # タグを紐づいている投稿が多い順に２０個取得
    @tags=TagPost.post_count.first(20)
  end

  ## 投稿詳細
  def show
    # 投稿を取得
    @post = Post.find(params[:id])
    # 取得した投稿に対してのタグを取得
    @post_tags = @post.tag_posts
    # 取得した投稿に対しての全コメントをページごとに取得
    @comments = @post.post_comments.page(params[:page]).per(5)
  end

  ## 投稿削除
  def destroy
    # 投稿を取得
    @post = Post.find(params[:id])
    # 取得した投稿を削除
    @post.destroy
    # タグに紐づいている投稿がなくなっていた場合タグの削除メソッド
    Post.tag_delete
    # 会員詳細へ
    redirect_to admin_customer_path(@post.customer_id),notice: "投稿情報を削除しました"
  end

  ## 全投稿削除
  def destroy_all
    # 会員に紐づいている全投稿を取得
    @posts = Customer.find(params[:customer_id]).posts
    # 取得した全投稿を削除
    @posts.destroy_all
    # タグに紐づいている投稿がなくなっていた場合タグの削除メソッド
    Post.tag_delete
    # 会員詳細へ
    redirect_to admin_customer_path(params[:customer_id]),notice: "投稿情報をすべて削除しました"
  end

  ## 投稿検索
  def search
    # 送られてきた値でsearchメソッドで検索しページごとに取得
    @posts = Post.latest.search(params[:keyword]).page(params[:page])
    # viewに何を検索しているのかを表示するため送られてきた値を取得
    @keyword = params[:keyword]
    # タグを紐づいている投稿が多い順に２０個取得
    @tags = TagPost.post_count.first(20)
    # 会員一覧へ
    render "index"
  end

  ## タグ検索
  def tag_search
    # タグを紐づいている投稿が多い順に２０個取得
    @tags = TagPost.post_count.first(20)
    # 検索されたタグを受け取る
    tag = TagPost.find(params[:tag_post_id])
    # 検索されたタグに紐づく投稿を表示
    @posts = tag.posts.page(params[:page])
    # viewに何を検索しているのかを表示するため送られてきた値を取得
    @tag_keyword = tag.name
    # 会員一覧へ
    render :index
  end

end
