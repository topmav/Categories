Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Remove the :show route and direct GET /categories/:id to the edit action
  resources :categories, except: [:show, :edit] do
    # UPDATED: include :update in the only: array for both keywords and sellers
    resources :keywords, only: [:create, :destroy, :update]
    resources :sellers, only: [:create, :destroy, :update]

    # New nested routes for form_questions and form_answers
    resources :form_questions, only: [:create, :update, :destroy] do
      resources :form_answers, only: [:create, :update, :destroy]
    end

    # Added nested routes for landing_page_images and ad_images
    resources :landing_page_images, only: [:create, :destroy, :index]
    resources :ad_images, only: [:create, :destroy, :index]
  end
  get "categories/:id", to: "categories#edit"

  root "categories#index"
end