class Spree::UserRegistrationsController < Devise::RegistrationsController
  helper 'spree/base', 'spree/store'

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Store

  before_action :check_permissions, only: [:edit, :update]
  skip_before_action :require_no_authentication

  def create
    if Spree::User.where(email: spree_user_params[:email], provider: "google_oauth2").present?
      flash[:error] = "User already register with an Google"
      redirect_to root_path
    else
      build_resource(spree_user_params)
      if resource.save
        set_flash_message(:notice, :signed_up)
        sign_in(:spree_user, resource)
        session[:spree_user_signup] = true
        respond_with(resource) do |format|
          format.html { redirect_to after_sign_up_path_for(resource)}
          format.js
        end
      else
        clean_up_passwords(resource)
        respond_with(resource) do |format|
          format.html { render :new }
          format.js
        end
      end

      Mailchimp::CreateNewCustomer.new( params.dig( :spree_user, :email )).call if Rails.env.production? && params[:subscribe_me].present?
    end
  end

  protected

  def translation_scope
    'devise.user_registrations'
  end

  def check_permissions
    authorize!(:create, resource)
  end

  private

  def spree_user_params
    params.require(:spree_user).permit(Spree::PermittedAttributes.user_attributes | [:email])
  end
end

# touched on 2025-05-22T20:35:38.213482Z
# touched on 2025-05-22T20:40:34.397009Z
# touched on 2025-05-22T22:32:59.854700Z
# touched on 2025-05-22T23:39:48.973185Z

# touched on 2025-06-13T21:15:12.350893Z