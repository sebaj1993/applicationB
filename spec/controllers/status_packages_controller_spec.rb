# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe StatusPackagesController, type: :controller do
  it 'Retorna badRequest por falta de parametros' do
    get :GetTrackingInformationInFedex
    expect(response.status).to eq 400
  end

  it 'Retorna badRequest por falta de parametro callback_url' do
    get :GetTrackingInformationInFedex, params: { tracking_number: '123456789' }
    expect(response.status).to eq 400
  end

  it 'Retorna badRequest por falta de parametro tracking_number' do
    get :GetTrackingInformationInFedex, params: { callback_url: 'http://CallBackUrl.com' }
    expect(response.status).to eq 400
  end

  it 'retorna request exitoso y aumenta cola de jobs' do
    get :GetTrackingInformationInFedex, params: { tracking_number: '123456789', callback_url: 'http://CallBackUrl.com' }
    expect(response.status).to eq 200
    expect(JSON.parse(response.body)['message']).to eq('Se esta solicitando el tracking a Fedex, ni bien tengamos novedades las comunicaremos a: http://CallBackUrl.com')
    expect(TrackingInformationFedexWorker.jobs.size).to eq(1)
  end
end
