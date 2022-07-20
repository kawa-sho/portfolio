class Guest::SessionsController < Devise::SessionsController
  # ゲストログイン機能
  def guest_sign_in
    # 会員でログインしているかの確認
    if customer_signed_in?
      # 会員詳細へ
      redirect_to customer_path(current_customer), alert: 'すでにログインしています。'
      # 管理者でログインしているかの確認
    elsif admin_signed_in?
      # 管理者のトップ画面へ
      redirect_to admin_root_path, alert: 'すでにログインしています。'
    else
      # ゲストメソッドでゲストを取得
      customer = Customer.guest
      # ログイン状態にする
      sign_in customer
      # 会員詳細へ
      redirect_to customer_path(customer), notice: 'ゲストでログインしました。'
    end
  end
end