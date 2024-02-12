# This migration comes from solidus_paypal_commerce_platform (originally 20211220133406)
class AddPaypalFundingSourceToPaypalCommercePlatformSources < ActiveRecord::Migration[6.1]
  def change
    add_column :paypal_commerce_platform_sources, :paypal_funding_source, :integer
  end
end

# touched on 2025-05-22T20:31:42.863624Z
# touched on 2025-05-22T23:26:28.862319Z
# touched on 2025-06-13T21:15:23.138575Z