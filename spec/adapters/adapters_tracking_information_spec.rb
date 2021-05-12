# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe AdaptersTrackingInformation::FedexTrackingInformation, type: :adapter do
  subject do
    described_class.new.tracking_information({ key: 'test',
                                               password: 'test',
                                               account_number: 'test',
                                               meter: 'test',
                                               mode: 'test' }, '123456789')
  end

  context 'En el caso de que fedex nos retorne respuesta exitosa' do
    before do
      allow_any_instance_of(Fedex::Request::TrackingInformation).to receive(:process_request).and_return([OpenStruct.new(
        tracking_number: '123456789', status_code: status_code
      )])
    end

    context 'En el caso de que el paquete fue delivered' do
      let(:status_code) { 'DL' }

      it 'Aumenta un registro de TrackingInformation' do
        expect { subject }.to change { TrackingInformation.count }.by(1)
      end

      it 'Recibimos respuesta exitosa' do
        expect(subject).to eq({ tracking_number: '123456789', status: 'DELIVERED', carrier: 'FEDEX' })
      end
    end

    context 'En el caso de que el paquete fue created' do
      let(:status_code) { 'OC' }

      it 'Aumenta un registro de TrackingInformation' do
        expect { subject }.to change { TrackingInformation.count }.by(1)
      end

      it 'Recibimos respuesta exitosa' do
        expect(subject).to eq({ tracking_number: '123456789', status: 'CREATED', carrier: 'FEDEX' })
      end
    end

    context 'En el caso de que el paquete fue exception' do
      let(:status_code) { 'DE' }

      it 'Aumenta un registro de TrackingInformation' do
        expect { subject }.to change { TrackingInformation.count }.by(1)
      end

      it 'Recibimos respuesta exitosa' do
        expect(subject).to eq({ tracking_number: '123456789', status: 'EXCEPTION', carrier: 'FEDEX' })
      end
    end

    context 'En el caso de que el paquete fue en transito' do
      let(:status_code) { 'IT' }

      it 'Aumenta un registro de TrackingInformation' do
        expect { subject }.to change { TrackingInformation.count }.by(1)
      end

      it 'Recibimos respuesta exitosa' do
        expect(subject).to eq({ tracking_number: '123456789', status: 'ON_TRANSIT', carrier: 'FEDEX' })
      end
    end
  end

  context 'En el caso de que fedex no encuentre el paquete' do
    before do
      allow_any_instance_of(Fedex::Request::TrackingInformation).to receive(:process_request).and_raise(
        Fedex::RateError, 'This tracking number cannot be found. Please check the number or contact the sender.'
      )
    end

    context 'Y tengamos registro de ese paquete en nuestra base de datos' do
      let!(:tracking_information_in_db) do
        TrackingInformation.create(tracking_number: '123456789', carrier: 'FEDEX', status: 'DELIVERED')
      end

      it 'Recibo respuesta de paquete en base de datos' do
        expect(subject).to eq({ tracking_number: '123456789', status: 'DELIVERED', carrier: 'FEDEX' })
      end
    end

    context 'Y no tengamos registro de ese paquete en nuestra base de datos' do
      it 'Recibo respuesta de no se encuentra ese trucking number' do
        expect(subject).to eq({ message: 'This tracking number cannot be found. Please check the number or contact the sender.' })
      end
    end
  end

  context 'En el caso de que devuelva un error el request a fedex' do
    before do
      allow_any_instance_of(Fedex::Request::TrackingInformation).to receive(:process_request).and_raise(
        Fedex::RateError, 'ERROR'
      )
    end

    it 'Recibo respuesta de error de request' do
      expect(subject).to eq({ message: 'ERROR' })
    end
  end
end
