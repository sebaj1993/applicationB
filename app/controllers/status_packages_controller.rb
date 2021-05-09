class StatusPackagesController < ApplicationController
    def GetTrackingInformationInFedex   
        TrackingInformationFedexWorker.perform_async(tracking_params[0], tracking_params[1])
        render :ok, json: { message: 'Se esta solicitando el tracking a Fedex, ni bien tengamos novedades las comunicaremos a: ' + tracking_params[1]}
    end

    private

    def tracking_params
        params.require([:tracking_number, :callback_url])
    end
end