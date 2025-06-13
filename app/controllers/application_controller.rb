class ApplicationController < ActionController::Base
  include Spree::Core::ControllerHelpers::Store
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::CurrentHost
  include Spree::Core::ControllerHelpers::Auth

  before_action :source_and_ref
  before_action :add_source_and_ref, if: -> {params[:ref] || params[:utm_source] || params[:tar]}

  private

  def add_source_and_ref
    cookies[:ref] = { value: params[:ref], expires: 7.day} if params.has_key?(:ref)
    cookies[:utm_source] = { value: params[:utm_source], expires: 30.day} if params.has_key?(:utm_source)
    cookies[:tar] = { value: params[:tar], expires: 7.day} if params.has_key?(:tar)
  end

  def source_and_ref
    params.permit(:utm_source, :ref, :tar)
  end
end

# touched on 2025-05-22T22:45:00.984136Z
