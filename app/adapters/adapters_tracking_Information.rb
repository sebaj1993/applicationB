# frozen_string_literal: true

module AdaptersTrackingInformation
  class AdapterTrackingInformation
    def tracking_information(_credentials, _tracking_number)
      raise 'this method must be implemented'
    end

    private

    def get_homologated_tracking(_code)
      raise 'this method must be implemented'
    end

    def get_tracking_information_in_db(tracking_number, carrier, message_cannot_be_found)
      if TrackingInformation.exists?(tracking_number: tracking_number)
        last_result = TrackingInformation.last_tracking_information({ tracking_number: tracking_number,
                                                                      carrier: carrier })
        { tracking_number: last_result.tracking_number, status: last_result.status,
          carrier: last_result.carrier }
      else
        { message: message_cannot_be_found }
      end
    end
  end

  class FedexTrackingInformation < AdapterTrackingInformation
    require 'fedex'
    require 'date'

    def tracking_information(credentials, tracking_number)
      credentials = Fedex::Credentials.new(credentials)
      fedex = Fedex::Request::TrackingInformation.new(credentials, { tracking_number: tracking_number })
      results = fedex.process_request
      tracking_info_result = results.first
      TrackingInformation.create(tracking_number: tracking_info_result.tracking_number, carrier: 'FEDEX',
                                 status: get_homologated_tracking(tracking_info_result.status_code))
      { tracking_number: tracking_info_result.tracking_number,
        status: get_homologated_tracking(tracking_info_result.status_code), carrier: 'FEDEX' }
    rescue Fedex::RateError => e
      if e.message == 'This tracking number cannot be found. Please check the number or contact the sender.'
        get_tracking_information_in_db(tracking_number, 'FEDEX', e.message)
      else
        { message: e.message }
      end
    end

    private

    def get_homologated_tracking(code)
      if ['OC'].include? code
        'CREATED'
      elsif ['DL'].include? code
        'DELIVERED'
      elsif ['DE'].include? code
        'EXCEPTION'
      else
        'ON_TRANSIT'
      end
    end
  end
end
