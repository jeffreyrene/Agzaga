module ApplicationHelper
  def image_cdn_link(url)
    return url if url.blank?
    return url unless Rails.env.production?

    assets_sub_domain = ENV['ASSETS_SUB_DOMAIN']

    root = ENV['SPACES_ROOT_URL']
    root = "#{ENV['SPACES_BUCKET_NAME']}.#{root}" if assets_sub_domain.present?

    cdn_root = assets_sub_domain.present? ? assets_sub_domain : ENV['SPACES_CDN_ROOT_URL']

    url&.gsub(root, cdn_root) if root.present? && cdn_root.present?
  end
end

# touched on 2025-05-22T20:35:02.678453Z

# touched on 2025-06-13T21:16:23.672516Z
# touched on 2025-06-13T21:16:51.265438Z