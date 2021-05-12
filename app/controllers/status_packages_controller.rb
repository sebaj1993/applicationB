# frozen_string_literal: true

class StatusPackagesController < ApplicationController
  def GetTrackingInformationInFedex
    if tracking_params[:tracking_number].present? && tracking_params[:callback_url].present?
      TrackingInformationFedexWorker.perform_async(tracking_params[:tracking_number],
                                                   tracking_params[:callback_url])
      render :ok,
             json: { message: "Se esta solicitando el tracking a Fedex, ni bien tengamos novedades las comunicaremos a: #{tracking_params[:callback_url]}" }
    else
      render json: { message: 'Parametros invalidos. Verifique' }, status: :bad_request
    end
  end

  private

  def tracking_params
    params.permit(:tracking_number, :callback_url)
  end
end
