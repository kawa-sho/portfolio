class Admin::PostCommentsController < ApplicationController
  def destroy
    # コメントの削除
    PostComment.find(params[:id]).destroy
    redirect_to request.referer,notice: "コメントを削除しました"
  end
end
