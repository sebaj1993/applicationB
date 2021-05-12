require "rails_helper"

RSpec.describe TrackingInformation, :type => :model do
    subject { described_class.new(tracking_number: "123456789", 
                                carrier: "aCarrier", status: 'OK')  }

    describe "Validations" do
      it "is valid with valid attributes" do
        expect(subject).to be_valid
      end

      it "is not valid without a tracking_number" do
        subject.tracking_number = nil
        expect(subject).to_not be_valid
      end

      it "is not valid without an carrier" do
        subject.carrier = nil
        expect(subject).to_not be_valid
      end

      it "is not valid without an status" do
        subject.status = nil
        expect(subject).to_not be_valid
      end
    end
end