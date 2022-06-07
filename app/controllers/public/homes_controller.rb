class Public::HomesController < Public::ApplicationController
  before_action :authenticate_customer!, except: [:top]

  def top
  end
end
