module AdaptersTrackingInformation
    class AdapterTrackingInformation
        def tracking_information(credentials, tracking_number); 
            raise "this method must be implemented"; 
        end

        private

        def get_homologated_tracking(code); 
            raise "this method must be implemented"; 
        end
    end

    class FedexTrackingInformation < AdapterTrackingInformation
        require 'fedex'
        
        def tracking_information(credentials, tracking_number)
            credentials = Fedex::Credentials.new(credentials)
            fedex = Fedex::Request::TrackingInformation.new(credentials, {:tracking_number => tracking_number})
            results = fedex.process_request
            tracking_info = results.first
            return {:tracking_number => tracking_info.tracking_number, :status => get_homologated_tracking(tracking_info.status_code), :carrier => 'FEDEX'}
        end

        private

        def get_homologated_tracking(code); 
            if ['OC'].include? code
                return 'CREATED'
            elsif ['DL'].include? code
                return 'DELIVERED'
            elsif ['DE'].include? code
                return 'EXCEPTION'
            else
                return 'ON_TRANSIT'
            end
        end
    end
end