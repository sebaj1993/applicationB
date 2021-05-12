# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrackingInformation, type: :model do
  subject do
    described_class.new(tracking_number: '123456789',
                        carrier: 'aCarrier', status: 'OK')
  end

  describe 'Validaciones' do
    it 'Es valido con todos los atributos completos' do
      expect(subject).to be_valid
    end

    it 'No es valido sin el tracking_number' do
      subject.tracking_number = nil
      expect(subject).to_not be_valid
    end

    it 'No es valido sin un carrier' do
      subject.carrier = nil
      expect(subject).to_not be_valid
    end

    it 'No es valido sin un status' do
      subject.status = nil
      expect(subject).to_not be_valid
    end
  end
end
