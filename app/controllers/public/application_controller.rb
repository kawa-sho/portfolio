class Public::ApplicationController < ApplicationController
  # 会員がログインしているかの確認
  before_action :authenticate_customer!
end
