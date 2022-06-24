# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  before_action :customer_signed_in
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end


  # 管理者でログインしているかと退会しているかの判断のメソッド
  protected

  def customer_signed_in
    if customer_signed_in?
      redirect_to customer_path(current_customer), alert: 'すでにログインしています。'
    end
  end

end
