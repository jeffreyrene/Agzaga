class Spree::Admin::FfaChapterEnrollmentsController < Spree::Admin::BaseController

  before_action :load_ffa_chapter, only: [:edit, :update, :destroy]

  def index
    @ffa_chapter = Spree::FfaChapter.order(id: :desc).page(params.dig(:page) || 1 ).per(30)
  end

  def update
    if @ffa_chapter.update(ffa_chapter_params)
      redirect_to admin_ffa_chapter_enrollments_path, notice: 'Updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    if @ffa_chapter.destroy
      redirect_to admin_ffa_chapter_enrollments_path, notice: 'Deleted successfully.'
    else
      render :index
    end
  end

  def export
    ExportFfaChapterJob.perform_later(spree_current_user)
    flash[:success] = 'CSV file will be emailed you shortly'
    redirect_to action: :index
  end

  private

  def load_ffa_chapter
    @ffa_chapter = Spree::FfaChapter.find(params[:id])
  end

  def ffa_chapter_params
    params.require(:ffa_chapter)
          .permit(:first_name, :last_name, :phone_number, :email,
                  :name, :members, :number, :ein_number,
                  :school_name, :street, :city, :state, :postal_code, :digital_signature, :consent_verified, :is_signed, :status, :advisor_form_downloaded, :selected)
  end
end

# touched on 2025-05-22T21:21:55.302847Z
# touched on 2025-05-22T23:08:16.556081Z
