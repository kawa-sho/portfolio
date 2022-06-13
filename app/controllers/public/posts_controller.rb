class Public::PostsController < Public::ApplicationController
  before_action :authenticate_customer!

  # ログインしてるアカウントと同じアカウントかどうかの確認
  before_action :correct_customer, only: [:edit, :update, :destroy]

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
    # 新しいコメントインスタンスの作成
    @post_comment = PostComment.new
    # 取得した投稿に対しての全コメントをページごとに取得
    @comments = @post.post_comments.page(params[:page]).per(5)
  end

  ## 投稿編集
  def edit
    # 投稿を取得
    @post = Post.find(params[:id])
    # フォームに入れるため
    @tag_lists= @post.tag_posts.pluck(:name).join(',')
  end

  ## 更新
  def update
    # 受け取った値を,で区切って配列にし、uniqで同じものを一つにする
    @tag_lists=params[:post][:name].delete(' ').delete('　').split(',').uniq
    # 投稿に紐づいているすべてのタグを削除
    @post.tag_posts.destroy_all
    # each文で回す
    @tag_lists.each do |tag_list|
      # TagPostのインスタンスを作る
      new_tag = TagPost.find_or_initialize_by(name: tag_list)
      # タグの保存
      new_tag.save
      # バリデーションをチェックする
      if new_tag.valid?
        # 投稿にタグを紐づける
        @post.tag_posts << new_tag
      else
        flash[:alert] = 'タグが10文字以上のものは削除しました'
      end
    end
    # 投稿の更新
    if @post.update(post_params)
      # メソッドの運用
      Post.tag_delete
      # 投稿詳細へ
      redirect_to post_path(@post),notice: "投稿情報を更新しました"
    else
      # 投稿編集へ
      render :edit
    end
  end

  ## 投稿削除
  def destroy
    # 投稿を取得
    post = Post.find(params[:id])
    # 取得した投稿を削除
    post.destroy
    # タグに紐づいている投稿がなくなっていた場合タグの削除メソッド
    Post.tag_delete
    # 会員詳細へ
    redirect_to customer_path(current_customer),alert: "投稿情報を削除しました"
  end

  ## 全投稿削除
  def destroy_all
    # ログインしている会員の全投稿を取得
    posts = current_customer.posts
    # 取得した全投稿を削除
    posts.destroy_all
    # タグに紐づいている投稿がなくなっていた場合タグの削除メソッド
    Post.tag_delete
    # 会員詳細へ
    redirect_to customer_path(current_customer),notice: "投稿情報をすべて削除しました"
  end

  ## 新規投稿
  def new
    # 投稿インスタンスを作成
    @post = Post.new
  end

  ## 投稿の作成
  def create
    # 投稿のインスタンスにパラメータを取得
    @post = Post.new(post_params)
    # 投稿のインスタンスにログインしている会員のidを渡す
    @post.customer_id = current_customer.id
    # 受け取った値を,で区切って配列にし、uniqで同じものを一つにする
    @tag_lists=params[:post][:name].delete(' ').delete('　').split(',').uniq
    # each文で回す
    @tag_lists.each do |tag_list|
      # TagPostのインスタンスを作る
      new_tag = TagPost.find_or_initialize_by(name: tag_list)
      # タグの保存
      new_tag.save
      # バリデーションをチェックする
      if new_tag.valid?
        # 投稿にタグを紐づける
        @post.tag_posts << new_tag
      else
        flash[:alert] = 'タグが10文字以上のものは削除しました'
      end
    end
    # 投稿の保存
    if @post.save
      # メソッドの運用
      Post.tag_delete
      # 投稿詳細へ
      redirect_to post_path(@post),notice: "投稿をしました"
    else
      # 新規投稿へ
      render :new
    end
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


  # 投稿パラメーターの許可
  # ログインしてるアカウントと同じアカウントかどうかの確認
  private

  def post_params
    params.require(:post).permit(:post)
  end

  def correct_customer
    @post= Post.find(params[:id])
    unless @post.customer == current_customer
      redirect_to post_path(@post), notice: '違う会員の投稿は編集できません'
    end
  end
end