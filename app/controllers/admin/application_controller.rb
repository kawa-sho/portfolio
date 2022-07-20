class Admin::ApplicationController < ApplicationController
  # 管理者でログインしているか確認
  before_action :authenticate_admin!
end
