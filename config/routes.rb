Inmytime::Application.routes.draw do
  match '/' => 'convert#current', :via => [:GET]
  match '*time.json', :to => 'convert#convert', :via => [:GET,:OPTIONS], :requirements => {:ext => 'json' }
  match '*time.xml', :to => 'convert#convert', :via => [:GET,:OPTIONS], :requirements => {:ext => 'xml' }
  match '*time.yaml', :to => 'convert#convert', :via => [:GET,:OPTIONS], :requirements => {:ext => 'yaml' }
  match '*time', :to => 'convert#index', :via => [:GET]
end