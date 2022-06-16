class Admin::HomesController < Admin::ApplicationController
  before_action :authenticate_admin!

  ## 会員一覧
  def top
    # 全会員情報をページで分けて取得
    @customers = Customer.page(params[:page])
    # ページ
    @page = params[:page]
  end

  ## 会員検索
  def search
    # 送られてきた値でsearchメソッドで検索しページごとに取得
    @customers = Customer.search(params[:keyword]).page(params[:page])
    # viewに何を検索しているのかを表示するため送られてきた値を取得
    @keyword = params[:keyword]
    # 会員一覧へ
    render :top
  end

end
