Rails.application.routes.draw do
  get 'run_playbooks/index'
  get 'playbooks/index'
  root to: 'sessions#index'
  post 'login_attempt', to: "sessions#login_attempt"
  resources :users
  delete 'host_types', to: 'host_types#destroy'
  resources :host_types
  delete 'host_roles', to: 'host_roles#destroy'
  resources :host_roles
  delete 'groups', to: 'groups#destroy'
  resources :groups
  delete 'hosts', to: 'hosts#destroy'
  resources :hosts
  resources :files
  delete 'users', to: 'users#destroy'
  post 'upload_file', to: 'files#upload_file'
  post 'create_dir', to: 'files#create_dir'
  post 'del_file_dir', to: 'files#delete'
  get 'download_file', to: 'files#download_file'
  resources :playbooks
  get 'run_play_book', to: 'run_playbooks#index'
  post 'start_playbook', to: 'run_playbooks#run'
  post 'get_output', to: 'run_playbooks#get_output'
  post 'host_search', to: 'hosts#search'
  get 'home', to: "home#index"
  get 'logout', to: "home#logout"
  get "app_settings", to: "settings#app_settings"
  get "general", to: "settings#general"
  post "settings_apply", to: "settings#settings_apply"
end
