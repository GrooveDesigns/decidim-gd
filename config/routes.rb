require 'sidekiq/web'

Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  get 'after_signup', to: 'static_pages#after_signup'
  mount Decidim::Core::Engine => '/'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  #
  # For Sidekiq
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  # sitemaps
  get 'sitemaps/kawanishi.xml' => redirect('https://manazuru-decidim-public.s3.ap-northeast-1.amazonaws.com/sitemaps/kawanishi.xml')
end
