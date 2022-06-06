class Public::PostsController < Public::ApplicationController
  # ログインしてるアカウントと同じアカウントかどうかの確認
  before_action :correct_customer, only: [:edit, :update]

  def index
    # 全投稿情報
    @posts = Post.latest.page(params[:page])
    # 全タグ投稿多い順で20個
    @tags=TagPost.post_count.first(20)
  end

  def show
    # そのページの投稿
    @post = Post.find(params[:id])
    # 投稿に対してのタグ
    @post_tags = @post.tag_posts
    # 新しいコメント
    @post_comment = PostComment.new
    # コメント一覧
    @comments = @post.post_comments
  end

  def edit
    # そのページの投稿情報
    @post = Post.find(params[:id])
  end

  def update
    # 投稿情報の更新
    # 受け取った値を,で区切って配列にする
    tag_list=params[:post][:name].split(',')
    if @post.update(post_params)
      @post.save_tag(tag_list)
      # メソッドの運用
      Post.tag_delete
      redirect_to post_path(@post),notice: "投稿情報を更新しました"
    else
      render :edit
    end
  end

  def destroy
    # 投稿情報の削除
    @post = Post.find(params[:id])
    @post.destroy
    Post.tag_delete
    redirect_to customer_path(current_customer),notice: "投稿情報を削除しました"
  end

  def destroy_all
    # 投稿情報の全削除
    @posts = current_customer.posts
    @posts.destroy_all
    Post.tag_delete
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
    # 受け取った値を,で区切って配列にする
    tag_list=params[:post][:name].split(',')
    if @post.save
      #メソッドを利用してのタグの保存
      @post.save_tag(tag_list)
      redirect_to post_path(@post),notice: "投稿をしました"
    else
      render :new
    end
  end

  def search
    # 検索情報抜き出し
    @posts = Post.latest.search(params[:keyword]).page(params[:page])
    @keyword = params[:keyword]
    @tags = TagPost.all
    render "index"
  end

  def tag_search
    # 全タグ投稿多い順で20個
    @tags = TagPost.post_count.first(20)
    # 検索されたタグを受け取る
    tag = TagPost.find(params[:tag_post_id])
    # 検索されたタグに紐づく投稿を表示
    @posts = tag.posts.page(params[:page])
    @tag_keyword = tag.name
    render :index
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