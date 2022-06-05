Rails.application.routes.draw do

  ## デバイス関連
  # 会員用
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  # ゲストログイン用
  devise_scope :customer do
    post 'customers/guest_sign_in', to: 'guest/sessions#guest_sign_in'
  end


  ## 管理者側
  namespace :admin do
    # トップページ
    root :to => 'homes#top'
    #会員関連ページ
    resources :customers, only: [:show, :edit, :update] do
        delete '/posts/destroy_all' => 'posts#destroy_all', as: 'destroy_all'
    end
    # 投稿関連ページ
    resources :posts, only: [:show,:destroy]
  end

  ## 会員側
  scope module: :public do
    # トップページ
    root :to => 'homes#top'
    # 会員関連ページ
    resources :customers, only: [:index,:show,:edit,:update] do
      get '/quit_check' => 'customers#quit_check', as: 'quit_check'
      patch '/withdraw' => 'customers#withdraw', as: 'withdraw'
      # 会員ごとのいいね一覧ページ
      get '/post_favorites' => 'post_favorites#index_customer'
    end
    # 投稿関連ページ
    delete '/posts/destroy_all' => 'posts#destroy_all'
    resources :posts, only: [:index,:show,:edit,:update,:destroy,:new,:create] do
      # 投稿ごとのいいね一覧ページといいね関連
      resource :post_favorites, only: [:index,:destroy,:create]
      # コメント関連
      resources :post_comments, only: [:destroy,:create]
    end
  end
end
