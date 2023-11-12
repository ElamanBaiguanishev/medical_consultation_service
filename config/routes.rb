Rails.application.routes.draw do
  get '/patients', to: 'patients#index'
  get '/patients/:id', to: 'patients#show'
  post '/patients', to: 'patients#create'
  patch '/patients/:id', to: 'patients#update'
  delete '/patients/:id', to: 'patients#destroy'

  post '/consultation_requests', to: 'consultation_requests#create'
  post '/consultation_requests/:request_id/recommendations', to: 'consultation_requests#create_recommendation'
  get '/patients/:id/recommendations', to: 'patients#recommendations'

end