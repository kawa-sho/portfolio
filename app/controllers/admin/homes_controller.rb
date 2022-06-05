class Admin::HomesController < Admin::ApplicationController

  def top
    # 全会員情報
    @customers = Customer.page(params[:page])
  end

end
