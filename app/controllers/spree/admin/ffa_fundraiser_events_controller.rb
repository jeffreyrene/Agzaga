class Spree::Admin::FfaFundraiserEventsController < Spree::Admin::BaseController

  before_action :load_event, only: :update

  def index
    @events = Spree::FfaFundraiserEvent.order(id: :desc)
                                       .page(params.dig(:page) || 1).per(15)
  end

  def create
    if Spree::FfaFundraiserEvent.create(started_by_id: spree_current_user.id, is_active: true)
      flash[:success] = "Event started successfully"
    else
      flash[:error] = "Something went wrong"
    end

    redirect_to action: :index
  end

  def update
    if @event.update(ended_by_id: spree_current_user.id, is_active: false, ended_at: DateTime.now)
      flash[:success] = "Event ended successfully"
    else
      flash[:error] = "Something went wrong"
    end

    redirect_to action: :index
  end

  private

  def load_event
    @event = Spree::FfaFundraiserEvent.find(params[:id])
  end
end

# touched on 2025-05-22T19:06:59.093688Z
# touched on 2025-05-22T20:37:57.948373Z
# touched on 2025-05-22T23:29:33.874872Z
# touched on 2025-05-22T23:36:47.272705Z

# touched on 2025-06-13T21:17:46.989767Z