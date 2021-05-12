class TrackingInformation < ApplicationRecord
    scope :last_tracking_information, lambda {|params| where(:tracking_number => params[:tracking_number], :carrier => params[:carrier])
        .order('created_at desc').first }
end