Inmytime::Application.routes.draw do
  match '/' => 'convert#current', :via => [:GET]
  match '*time', :to => 'convert#index', :via => [:GET]
end