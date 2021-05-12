# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe TrackingInformationFedexWorker, type: :worker do
  it 'Se agrega un job a la cola del worker' do
    expect do
      TrackingInformationFedexWorker.perform_async('123456789',
                                                   'http://CallBackUrl.com')
    end.to change(TrackingInformationFedexWorker.jobs, :size).by(1)
  end

  it 'Envia request a CallbackUrl' do
    expect(Faraday).to receive(:post).with('http://CallBackUrl.com')
    TrackingInformationFedexWorker.new.perform('123456789', 'http://CallBackUrl.com')
  end
end
