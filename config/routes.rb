Rails.application.routes.draw do
  get "top", to: "top#index", as: "top"
  get "tos", to: "top#tos", as: "tos"
  get "pp", to: "top#pp", as: "pp"
  devise_for :users
  root to: "products#index"
  resources :monthly_consume_amount, only: %i(index)
  get "monthly_consume_amount/:year/:month", to: "monthly_consume_amount#show", as: :monthly_log
  resources :products do
    resources :product_consume_logs do
      resources :use_end, only: %i(index), controller: "product_consume_logs/use_end"
    end
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
