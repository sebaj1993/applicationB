class StatusPackagesController < ApplicationController
    require_relative '../adapters/adapters_tracking_Information'
    include AdaptersTrackingInformation

    def GetTrackingInformationInFedex
        result = FedexTrackingInformation.new.tracking_information({key: 'VZ0tu2xxC4LKxZY6',
                                                                    password: 'AKOh8wjdYsJtNI6CFKaxPFLka',
                                                                    account_number: '802388543',
                                                                    meter: '100495015',
                                                                    mode: 'test'}, tracking_params)
        render json: result
    end

    private

    def tracking_params
        params.require(:tracking_number)
    end
end