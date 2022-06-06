class Admin::PostsController < ApplicationController

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
    # コメント一覧
    @comments = @post.post_comments
  end

  def destroy
    # 投稿情報の削除
    @post = Post.find(params[:id])
    @post.destroy
    Post.tag_delete
    redirect_to admin_customer_path(@post.customer_id),notice: "投稿情報を削除しました"
  end

  def destroy_all
    # 投稿情報の全削除
    @posts = Customer.find(params[:customer_id]).posts
    @posts.destroy_all
    Post.tag_delete
    redirect_to admin_customer_path(params[:customer_id]),notice: "投稿情報をすべて削除しました"
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

end
