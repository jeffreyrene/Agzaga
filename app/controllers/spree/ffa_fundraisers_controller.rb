module Spree
  class FfaFundraisersController < Spree::StoreController
    include Wicked::Wizard
    layout 'spree/layouts/ffa'

    before_action :limit_access, :load_ffa_chapter, only: [:show, :update]
    before_action :set_params_with_status, only: [:update]

    steps :start, :user_info, :chapter_info, :school_info, :signature, :thankyou

    def show
      respond_to do |format|
        format.js
        format.html {render_wizard}
      end
    end

    def update
      if @ffa_chapter.update(ffa_chapter_params)
        session[:chapter_id] = nil if step == :signature
      end

      respond_to do |format|
        format.js
        format.html {redirect_to(wizard_path(next_step))}
      end
    end

    def create
      params[:ffa_chapter][:status] = :user_info

      @ffa_chapter = Spree::FfaChapter.create(ffa_chapter_params)

      session[:chapter_id] = @ffa_chapter.id if @ffa_chapter.id.present?

      respond_to do |format|
        format.js
        format.html {redirect_to(wizard_path(:chapter_info))}
      end
    end

    private

    def limit_access
      redirect_to wizard_path(steps.first) if (session[:chapter_id].blank? || request.format.html?) && !steps.first(2).include?(step)
    end

    def set_params_with_status
      params[:ffa_chapter][:status] = step
      params[:ffa_chapter][:status] = 'completed' if next_step == steps.last
    end

    def load_ffa_chapter
      @ffa_chapter = Spree::FfaChapter.find_by(id: session[:chapter_id])
      @ffa_chapter = Spree::FfaChapter.new() if @ffa_chapter.blank?
    end

    def ffa_chapter_params
      params.require(:ffa_chapter)
            .permit(:first_name, :last_name, :phone_number, :email,
                    :name, :members, :number, :ein_number,
                    :school_name, :street, :city, :state, :postal_code, :digital_signature, :consent_verified, :status, :advisor_form_downloaded)
    end
  end
end

# touched on 2025-05-22T20:44:44.571381Z
# touched on 2025-05-22T23:29:10.409789Z

# touched on 2025-06-13T21:19:59.351263Z