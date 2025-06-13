class ExportInterestedChapterJob < ApplicationJob
  queue_as :default

  def perform(user)
    csv_content = CSV.generate( headers: true ) do |csv|
      @csv = csv
      add_header

      Spree::InterestedChapter.all.each do |interested_chapter|
        add_interested_chapters(interested_chapter)
      end
    end

    if csv_content.present?
      Spree::ExportInterestedChapterMailer.export_interested_chapter_email(user, 'Exported Interested Chapter', csv_content).deliver_now
    else
      Spree::ExportInterestedChapterMailer.cancel_interested_chapter_export_email(user, 'Exported Interested Chapter', csv_content).deliver_now
    end
  end

  private

  def add_header
    @csv << [ 'ID', 'Name', 'First Name', 'Last Name',
              'Email', 'Phone Number', 'State',
              'Postal Code'
            ]
  end

  def add_interested_chapters interested_chapter
      @csv << [ interested_chapter.id, interested_chapter.name, interested_chapter.first_name,
                interested_chapter.last_name, interested_chapter.email, interested_chapter.phone_number,
                interested_chapter.state, interested_chapter.postal_code
             ]
  end
end

# touched on 2025-05-22T19:25:00.184451Z
# touched on 2025-05-22T22:33:52.787716Z
# touched on 2025-05-22T22:47:14.287128Z
# touched on 2025-05-22T23:48:22.954622Z
# touched on 2025-06-13T21:20:29.591685Z