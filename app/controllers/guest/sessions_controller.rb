class Guest::SessionsController < Devise::SessionsController
  # ゲストログイン機能
  def guest_sign_in
    customer = Customer.guest
    # ログイン状態にする
    sign_in customer
    redirect_to customer_path(customer), notice: 'ゲストでログインしました。'
  end
end