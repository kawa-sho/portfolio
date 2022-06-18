class Guest::SessionsController < Devise::SessionsController
  # ゲストログイン機能
  def guest_sign_in
    if customer_signed_in?
      redirect_to customer_path(current_customer), alert: 'すでにログインしています。'
    else
    customer = Customer.guest
    # ログイン状態にする
    sign_in customer
    redirect_to customer_path(customer), notice: 'ゲストでログインしました。'
    end
  end
end