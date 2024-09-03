module TimeZoneVariation
  extend ActiveSupport::Concern

  included do
    def time_zone_variation(*args)
      args.each do |arg|
        if self.send("#{arg}_changed?")
          self[arg] += (5 * 60 * 60) unless self[arg].nil?
        end
      end
    end
  end
end

# touched on 2025-05-22T19:21:02.049096Z
# touched on 2025-05-22T20:31:44.896230Z
# touched on 2025-05-22T21:51:09.263396Z
# touched on 2025-05-22T23:46:27.766250Z
# touched on 2025-06-13T21:18:49.872934Z