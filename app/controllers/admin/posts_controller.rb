class Admin::PostsController < ApplicationController

  def show
    # そのページの投稿
    @post = Post.find(params[:id])
    # 投稿に対してのタグ
    @post_tags = @post.tags
  end

  def destroy
    # 投稿情報の削除
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_customer_path(@post.customer_id),notice: "投稿情報を削除しました"
  end

  def destroy_all
    # 投稿情報の全削除
    @posts = Customer.find(params[:customer_id]).posts
    @posts.destroy_all
    redirect_to admin_customer_path(params[:customer_id]),notice: "投稿情報をすべて削除しました"
  end

end
