Rails.application.routes.draw do

  namespace :admin do
    get 'relationships/followings'
    get 'relationships/followers'
  end
  namespace :public do
    get 'relationships/followings'
    get 'relationships/followers'
  end
  ### デバイス関連
  ## 会員用
  devise_for :customers,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  ## 管理者用
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  ## ゲストログイン用
  devise_scope :customer do
    post 'customers/guest_sign_in', to: 'guest/sessions#guest_sign_in'
  end


  ### 管理者側
  namespace :admin do

    ## 会員関連
    # トップページ(会員一覧ページ)
    root :to => 'homes#top'
    # 会員検索機能
    get 'customer_search' => 'homes#search'
    # 会員詳細ページ　編集ページ　更新機能
    resources :customers, only: [:show, :edit, :update] do
      # 会員ごとの投稿全削除機能
      delete '/posts/destroy_all' => 'posts#destroy_all', as: 'destroy_all'
      # 会員ごとのいいね一覧ページ
      get '/post_favorites' => 'post_favorites#index_customer'
      # 会員ごとのコメント一覧ページ
      get '/post_comments' => 'post_comments#index'
      # 会員ごとのコメント全削除機能
      delete '/post_comments' => 'post_comments#destroy_all'
      # フォロー一覧ページ
      get 'followings' => 'relationships#followings', as: 'followings'
      # フォロワー一覧ページ
      get 'followers' => 'relationships#followers', as: 'followers'
    end

    ## 投稿関連
    # 投稿検索機能
    get 'post_search' => 'posts#search'
    # 投稿一覧ページ　詳細ページ　削除機能
    resources :posts, only: [:index,:show,:destroy] do
      #投稿ごとのいいね一覧ページ
      get 'post_favorites' => 'post_favorites#index'
      # コメント削除機能
      resources :post_comments, only: [:destroy]
    end

    ## 投稿タグ検索機能
    get "tag_search"=>"posts#tag_search"

  end


  ### 会員側
  scope module: :public do

    ## トップページ
    root :to => 'homes#top'

    ## 会員関連
    # 会員検索機能
    get 'customer_search' => 'customers#search'
    # 会員一覧ページ　詳細ページ　編集ページ　更新機能
    resources :customers, only: [:index,:show,:edit,:update] do
      # 退会確認ページ
      get '/quit_check' => 'customers#quit_check', as: 'quit_check'
      # 退会機能
      patch '/withdraw' => 'customers#withdraw', as: 'withdraw'
      # 会員ごとのいいね一覧ページ
      get '/post_favorites' => 'post_favorites#index_customer'
      # 会員ごとのコメント一覧ページ
      get '/post_comments' => 'post_comments#index'
      # 会員ごとのコメント全削除機能
      delete '/post_comments' => 'post_comments#destroy_all'
      # 会員ごとのフォロー作成機能　削除機能
      resource :relationships, only: [:create, :destroy]
      # フォロー一覧ページ
      get 'followings' => 'relationships#followings', as: 'followings'
      # フォロワー一覧ページ
      get 'followers' => 'relationships#followers', as: 'followers'
    end

    ## 投稿関連ページ
    # 投稿検索機能
    get 'post_search' => 'posts#search'
    # 投稿全削除機能
    delete '/posts/destroy_all' => 'posts#destroy_all'
    # 投稿一覧ページ　詳細ページ　編集ページ　更新機能　削除機能　新規登録ページ　新規作成機能
    resources :posts, only: [:index,:show,:edit,:update,:destroy,:new,:create] do
      # 投稿ごとのいいね一覧ページ
      get 'post_favorites' => 'post_favorites#index'
      # 投稿ごとのいいね削除機能　作成機能
      resource :post_favorites, only: [:destroy,:create]
      # 投稿ごとのコメント削除機能　作成機能
      resources :post_comments, only: [:destroy,:create]
    end

    ## 投稿タグ検索機能
    get "tag_search"=>"posts#tag_search"

    ## DM機能
    # メッセージ作成
    resources :messages, only: [:index,:create]
    # ルーム作成
    resources :rooms, only: [:index,:create,:show] do
      # ルームログ
      get 'rooms' => 'rooms#index_all'
    end

    ## グループ機能
    # グループメッセージ
    resources :group_messages, only: [:create]
    # グループデストロイ以外
    resources :groups do
      # グループチャット部屋
      get 'room' => 'groups#room'
      get 'room_log' => 'groups#room_log'
    end
  end


end
