class Public::HomesController < Public::ApplicationController
  before_action :authenticate_customer!, except: [:top]
  
  ## トップ
  def top
  end
end
