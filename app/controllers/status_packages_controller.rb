class StatusPackagesController < ApplicationController
    require_relative '../adapters/adapters_tracking_Information'
    include AdaptersTrackingInformation

    def GetTrackingInformationInFedex
        result = FedexTrackingInformation.new.tracking_information({key: 'VZ0tu2xxC4LKxZY6',
                                                                    password: 'AKOh8wjdYsJtNI6CFKaxPFLka',
                                                                    account_number: '802388543',
                                                                    meter: '100495015',
                                                                    mode: 'test'}, "149331877648230")
        render json: result
    end
end