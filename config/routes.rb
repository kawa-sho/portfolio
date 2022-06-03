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

  ## 管理者側
  namespace :admin do
    # トップページ
    root :to => 'homes#top'
    #会員関連ページ
    resources :customers, only: [:index, :show, :edit, :update]
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
    resources :posts, only: [:index,:show,:destroy,:new,:create] do
      # 投稿ごとのいいね一覧ページといいね関連
      resource :post_favorites, only: [:index,:destroy,:create]
      # コメント関連
      resources :post_comments, only: [:destroy,:create]
    end
  end
end
