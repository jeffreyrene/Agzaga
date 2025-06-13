class ExportFfaFundraiserJob < ApplicationJob
  queue_as :default

  def perform(user, params)
    csv_content = CSV.generate( headers: true ) do |csv|
      @csv = csv
      add_header
      @selected_chapter = Spree::FfaChapter.joins(:orders)
                                         .select("spree_ffa_chapters.id, spree_ffa_chapters.created_at, name, school_name, sum(spree_orders.item_total * 0.05) as sub_total, count(*) as orders_count")
                                         .where("spree_orders.state = 'complete'")
                                         .group(:id).order(id: :desc)
      @selected_chapter = @selected_chapter.ransack(params).result

      @selected_chapter.all.each do |selected_chapter|
        add_selected_chapters(selected_chapter)
      end
    end

    if csv_content.present?
      Spree::ExportFfaFundraiserMailer.export_ffa_fundraiser_email(user, 'Exported FFA Fundraiser', csv_content).deliver_now
    else
      Spree::ExportFfaFundraiserMailer.cancel_ffa_fundraiser_export_email(user, 'Exported FFA Fundraiser', csv_content).deliver_now
    end
  end

  private

  def add_header
    @csv << [ 'Id', 'Chapter Name', 'School Name',
              '5% of Orders', 'Count of Orders', 'Created at',
            ]
  end

  def add_selected_chapters selected_chapter
    @csv << [ selected_chapter.id, selected_chapter.name, selected_chapter.school_name,
              selected_chapter.sub_total.round(2), selected_chapter.orders_count, selected_chapter.created_at
            ]
  end
end

# touched on 2025-05-22T23:07:10.119741Z
# touched on 2025-05-22T23:25:26.232208Z
# touched on 2025-05-22T23:42:15.702942Z
