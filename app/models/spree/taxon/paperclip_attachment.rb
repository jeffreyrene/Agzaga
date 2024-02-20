# frozen_string_literal: true

module Spree::Taxon::PaperclipAttachment
  extend ActiveSupport::Concern

  included do
    has_attached_file :icon,
      styles: { mini: '32x32>', normal: '128x128>', medium: '250x250>' },
      default_style: :mini,
      url: '/spree/taxons/:id/:style/:basename.:extension',
      path: Rails.env.production? ? 'taxons/:id/:style/:basename.:extension' : ':rails_root/public/spree/taxons/:id/:style/:basename.:extension',
      default_url: '/assets/default_taxon.png'

    has_attached_file :small_ads,
      styles: { mini: '32x32>', normal: '128x128>', medium: '680x680>' },
      default_style: :medium,
      url: '/spree/taxons/:id/:style/:basename.:extension',
      path: Rails.env.production? ? 'taxons/:id/:style/:basename.:extension' : ':rails_root/public/spree/taxons/:id/:style/:basename.:extension',
      default_url: '/assets/default_taxon.png'

    has_attached_file :large_ads,
      styles: { mini: '32x32>', normal: '128x128>', medium: '250x250>', large: '1200x1200>' },
      default_style: :mini,
      url: '/spree/taxons/:id/:style/:basename.:extension',
      path: Rails.env.production? ? 'taxons/:id/:style/:basename.:extension' : ':rails_root/public/spree/taxons/:id/:style/:basename.:extension',
      default_url: '/assets/default_taxon.png'

    has_attached_file :small_ad_for_mobile,
      styles: { mini: '32x32>', normal: '128x128>', medium: '380x380>', large: '1200x1200>' },
      default_style: :medium,
      url: '/spree/taxons/:id/:style/:basename.:extension',
      path: Rails.env.production? ? 'taxons/:id/:style/:basename.:extension' : ':rails_root/public/spree/taxons/:id/:style/:basename.:extension',
      default_url: '/assets/default_taxon.png'

    has_attached_file :large_ad_for_mobile,
      styles: { mini: '32x32>', normal: '128x128>', medium: '380x380>', large: '1200x1200>' },
      default_style: :mini,
      url: '/spree/taxons/:id/:style/:basename.:extension',
      path: Rails.env.production? ? 'taxons/:id/:style/:basename.:extension' : ':rails_root/public/spree/taxons/:id/:style/:basename.:extension',
      default_url: '/assets/default_taxon.png'

    validates_attachment :icon,
      content_type: { content_type: %w[image/jpg image/jpeg image/png image/gif] }

    validates_attachment :small_ads,
      content_type: { content_type: %w[image/jpg image/jpeg image/png image/gif video/mp4] }

    validates_attachment :large_ads,
      content_type: { content_type: %w[image/jpg image/jpeg image/png image/gif] }

    validates_attachment :small_ad_for_mobile,
      content_type: { content_type: %w[image/jpg image/jpeg image/png image/gif] }

    validates_attachment :large_ad_for_mobile,
      content_type: { content_type: %w[image/jpg image/jpeg image/png image/gif] }
  end

  def icon_present?
    icon.present?
  end

  def small_ads_present?
    small_ads.present?
  end

  def large_ads_present?
    large_ads.present?
  end

  def small_ad_for_mobile_present?
    small_ad_for_mobile.present?
  end

  def large_ad_for_mobile_present?
    large_ad_for_mobile.present?
  end

  def destroy_attachment(definition)
    return false unless respond_to?(definition)

    attached_file = send(definition)
    return false unless attached_file.exists?

    attached_file.destroy
  end
end

# touched on 2025-05-22T20:44:27.506301Z
# touched on 2025-05-22T22:55:35.611491Z
