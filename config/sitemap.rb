SitemapGenerator::Sitemap.default_host = "https://#{Spree::Store.default.url}"
SitemapGenerator::Sitemap.compress = false
##
## If using Heroku or similar service where you want sitemaps to live in S3 you'll need to setup these settings.
##

## Pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'

# Store on S3 using Fog - Note must add fog to your Gemfile.
SitemapGenerator::Sitemap.adapter = SitemapGenerator::FogAdapter.new(
  storage: :fog,
    fog_credentials: {
      provider: 'AWS',
      aws_access_key_id: ENV['SPACES_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['SPACES_SECRET_ACCESS_KEY'],
      region: ENV['SPACES_REGION_NAME'],
      endpoint: 'https://'+ ENV['SPACES_ROOT_URL'],
    },
    fog_directory: ENV['SPACES_BUCKET_NAME'],
    fog_host: 'https://'+ ENV['SPACES_BUCKET_NAME']+ '.' + ENV['SPACES_ROOT_URL'])

## Inform the map cross-linking where to find the other maps.
# SitemapGenerator::Sitemap.sitemaps_host = 'https://'+ ENV['SPACES_BUCKET_NAME']+ '.' + ENV['SPACES_ROOT_URL']

## Pick a namespace within your bucket to organize your maps. Note you'll need to set this directory to be public.
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options = {})
  #        (default options are used if you don't specify)
  #
  # Defaults: priority: 0.5, changefreq: 'weekly',
  #           lastmod: Time.now, host: default_host
  #
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, priority: 0.7, changefreq: 'daily'
  #
  # Add individual articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), lastmod: article.updated_at
  #   end
  # add_login
  # add_signup
  # add_account
  # add_password_reset
  add_taxons
  add_products
end

# touched on 2025-05-22T19:24:50.141111Z
# touched on 2025-05-22T22:38:42.249795Z
# touched on 2025-05-22T23:04:19.071412Z
# touched on 2025-05-22T23:47:31.580469Z
# touched on 2025-05-22T23:48:05.442562Z
# touched on 2025-06-13T21:19:16.546613Z