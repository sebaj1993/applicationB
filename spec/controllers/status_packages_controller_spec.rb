require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe StatusPackagesController, type: :controller do
    it 'retorna error por falta de los dos parametros' do
        get :GetTrackingInformationInFedex
        expect(response.status).to eq 400
    end

     it 'retorna error por falta de parametro callback_url' do
         get :GetTrackingInformationInFedex, params: {tracking_number: '123456789'}
         expect(response.status).to eq 400
     end

    it 'retorna request correcto con mensaje' do
        get :GetTrackingInformationInFedex, params: {callback_url: 'http://hola.com/'}
         expect(response.status).to eq 400
    end

    it 'retorna request exitoso' do
        get :GetTrackingInformationInFedex, params: {tracking_number: '123456789', callback_url: 'http://hola.com/'}
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['message']).to eq ('Se esta solicitando el tracking a Fedex, ni bien tengamos novedades las comunicaremos a: http://hola.com/')
        expect(TrackingInformationFedexWorker.jobs.size).to eq (1)
    end
end