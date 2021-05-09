Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'StatusPackages/GetTrackingInformationInFedex/', to: 'status_packages#GetTrackingInformationInFedex'
end
