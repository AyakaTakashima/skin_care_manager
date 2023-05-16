Rails.application.routes.draw do
  get "welcome", to: "welcome#index", as: "welcome"
  get "tos", to: "welcome#tos", as: "tos"
  get "pp", to: "welcome#pp", as: "pp"
  devise_for :users
  root to: "products#index"
  get "monthly_consume_amount", to: "monthly_consume_amount#index"
  get "monthly_consume_amount/:year/:month", to: "monthly_consume_amount#show", as: :monthly_log
  resources :products do
    resources :product_consume_logs
    get "product_consume_logs/:id/use_end", to: "product_consume_logs#use_end", as: :use_end
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
