module Spree
  class NsProductsDataSyncsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      if params[:price_data]
        NsPriceUpdateJob.perform_later(data_sync_params[:price_data])
        render json: {data: 'NS post call Received'}.to_json, status: 200
      elsif params[:dropship_data]
        NsDropshipItemsSyncJob.perform_later(data_sync_params[:dropship_data])
        render json: {data: 'NS post call Received'}.to_json, status: 200
      else
        request_payload = data_sync_params[:context] || data_sync_params[:data]
        NsQuantityUpdateJob.perform_later(request_payload, data_sync_params[:data].present?)
        render json: {data: 'NS post call Received'}.to_json, status: 200
      end
    end

    def data_sync_params
      params.permit(:context, :data, :price_data, :dropship_data)
    end
  end
end

# touched on 2025-05-22T23:19:00.346283Z
