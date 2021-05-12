require 'rails_helper' 
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe TrackingInformationFedexWorker, type: :worker do
    it 'agrega una tarea a la queue' do
        expect { TrackingInformationFedexWorker.perform_async('123456789', 'http://hola.com') }.to change(TrackingInformationFedexWorker.jobs, :size).by(1)
    end

    it 'request exitoso de post' do
        expect(Faraday).to receive(:post).with('http://hola.com')
        TrackingInformationFedexWorker.new.perform('123456789', 'http://hola.com')
    end 
end