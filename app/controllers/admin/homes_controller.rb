class Admin::HomesController < Admin::ApplicationController
  before_action :authenticate_admin!

  def top
    # 全会員情報
    @customers = Customer.page(params[:page])
  end

  def search
    # 検索情報抜き出し
    @customers = Customer.search(params[:keyword]).page(params[:page])
    @keyword = params[:keyword]
    render :top
  end

end
