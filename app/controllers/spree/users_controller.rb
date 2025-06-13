# frozen_string_literal: true

class Spree::UsersController < Spree::StoreController
  skip_before_action :set_current_order, only: :show, raise: false
  prepend_before_action :load_object, only: [:show, :edit, :update]
  prepend_before_action :authorize_actions, only: :new

  include Spree::Core::ControllerHelpers
  include Users::OrderFilters


  def show
    @orders = filter_orders
  end

  def create
    @user = Spree::User.new(user_params)
    if @user.save

      if current_order
        session[:guest_token] = nil
      end

      redirect_back_or_default(root_url)
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      spree_current_user.reload
      redirect_url = spree.account_url

      if params[:user][:password].present? || params[:user][:email].present?
        bypass_sign_in(@user)
        flash[:success] = t('spree.account_updated')
        respond_to do |format|
          format.js
          format.html { redirect_to redirect_url, notice: I18n.t('spree.account_updated') }
        end
      else
        redirect_to redirect_url, notice: I18n.t('spree.account_updated')
      end
    else
      respond_to do |format|
        format.js
        format.html { render :edit }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(Spree::PermittedAttributes.user_attributes | [:email])
  end

  def load_object
    @user ||= Spree::User.find_by(id: spree_current_user&.id)
    authorize! params[:action].to_sym, @user
  end

  def authorize_actions
    authorize! params[:action].to_sym, Spree::User.new
  end

  def accurate_title
    I18n.t('spree.my_account')
  end
end

# touched on 2025-05-22T22:32:12.725783Z
# touched on 2025-05-22T22:43:15.129885Z
# touched on 2025-05-22T23:42:51.384543Z
