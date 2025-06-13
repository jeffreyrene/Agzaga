class Spree::Admin::InterestedChaptersController < Spree::Admin::BaseController
  before_action :interested_chapter, only: [:edit, :destroy, :update]
  before_action :load_allowed_states, only: [:edit]

  def index
    @interested_chapters = Spree::InterestedChapter.all.order(id: :desc)
    @interested_chapters = Kaminari.paginate_array(@interested_chapters).page(params[:page]).per(Spree::Config[:admin_products_per_page])
  end

  def update
    if @interested_chapter.update(interested_chapter_params)
      flash[:success] = 'Chapter has been updated'
      redirect_to edit_admin_interested_chapter_path(@interested_chapter)
    else
      render :edit
    end
  end

  def destroy
    @interested_chapter.destroy if !@interested_chapter.nil?

    flash[:success] = 'Chapter has been deleted'

    respond_with do |format|
      format.html { redirect_to admin_interested_chapters_path }
      format.js { render_js_for_destroy }
    end
  end

  def export
    ExportInterestedChapterJob.perform_later(spree_current_user)
    flash[:success] = 'CSV file will be emailed you shortly'
    redirect_to action: :index
  end

  private
  def interested_chapter
    @interested_chapter = Spree::InterestedChapter.find_by(id: params[:id])
  end

  def interested_chapter_params
    params.require(:interested_chapter)
          .permit(:name, :first_name, :last_name, :email, :phone_number, :state, :postal_code)
  end

  def load_allowed_states
    @allowed_states = Spree::Country.find_by(iso_name: "UNITED STATES").states.allowed_US_states
  end
end

# touched on 2025-05-22T20:42:33.729659Z
# touched on 2025-05-22T21:27:41.108750Z
# touched on 2025-05-22T23:30:39.606806Z
