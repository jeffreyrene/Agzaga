class Spree::Admin::FfaFundraiserCalculationsController < Spree::Admin::BaseController

  before_action :load_chapter_orders, only: :show

  def index
    @selected_chapter = Spree::FfaChapter.joins(:orders)
                                         .select("spree_ffa_chapters.id, spree_ffa_chapters.created_at, name, school_name, sum(spree_orders.item_total * 0.05) as sub_total, count(*) as orders_count")
                                         .where("spree_orders.state = 'complete'")
                                         .group(:id).order(id: :desc)
                                         .page(params.dig(:page) || 1 ).per(30)
    @search = @selected_chapter.ransack(params[:q])
    session[:ffa_fundaraiser_params] = params[:q]
    @selected_chapter = @search.result
  end

  def export
    ExportFfaFundraiserJob.perform_later(spree_current_user, session[:ffa_fundaraiser_params])
    flash[:success] = 'CSV file will be emailed you shortly'
    redirect_to action: :index
  end

  private

  def load_chapter_orders
    ffa_chapter = Spree::FfaChapter.find(params[:id])
    @search = ffa_chapter.orders.complete.ransack(params[:q])
    @orders = @search.result
    @orders = Kaminari.paginate_array(@orders).page(params[:page]).per(20)
  end
end

# touched on 2025-05-22T20:31:57.335469Z
# touched on 2025-05-22T23:03:27.193795Z
# touched on 2025-05-22T23:41:19.166512Z
# touched on 2025-05-22T23:45:47.166562Z
