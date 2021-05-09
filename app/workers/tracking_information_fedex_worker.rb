class TrackingInformationFedexWorker
  include Sidekiq::Worker
  require_relative '../adapters/adapters_tracking_Information'
  include AdaptersTrackingInformation
  require "faraday"

  def perform(tracking_number, callback_url)
    result = FedexTrackingInformation.new.tracking_information({key: 'VZ0tu2xxC4LKxZY6',
                                                        password: 'AKOh8wjdYsJtNI6CFKaxPFLka',
                                                        account_number: '802388543',
                                                        meter: '100495015',
                                                        mode: 'test'}, tracking_number)
    
    response = Faraday.post callback_url do |request|
      request.body = URI.encode_www_form(result)
    end
  end
end
