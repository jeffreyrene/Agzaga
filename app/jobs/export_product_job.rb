class ExportProductJob < ApplicationJob
  queue_as :default

  def perform(user)
    csv_content = CSV.generate( headers: true ) do |csv|
      @csv = csv
      add_header

      Spree::Product.all.each do |product|
        @product = product
        load_product_data
        master_variant
        export_data_to_csv_file
      end
    end

    if csv_content.present?
      Spree::ExportProductMailer.export_product_email(user, 'Exported Products', csv_content).deliver_now
    else
      Spree::ExportProductMailer.cancel_export_email(user, 'Exported Products', csv_content).deliver_now
    end
  end

  private

  def add_header
    @csv << [ 'Handle', 'Title', 'description', 'SKU', 'Meta Title', 'Meta Keywords', 'Meta Description', 'Published',
              'Published At', 'Discontinue', 'Discontinue At', 'Price', 'Promotionable', 'Taxon Permalink', 'Taxon Name',
              'Property Name', 'Property Value', 'Image Src', 'Stock', 'Backorderable', 'Stock Location Name', 'Variant SKU', 'Variant Cost Price',
              'Variant Image', 'Image Alt Text', 'Variant Weight', 'Variant Height', 'Variant Depth', 'Variant Width', 'Option1 Name',
              'Option1 Value', 'Option1 Presentation', 'Option2 Name', 'Option2 Value', 'Option2 Presentation', 'Option3 Name', 'Option3 Value', 'Option3 Presentation'
            ]
  end

  def load_product_data
    @published = ( @product.available_on ).to_s.present?  ? 'true' : 'false'
    @discontinue = ( @product.discontinue_on ).to_s.present? ? 'true' : 'false'
  end

  def master_variant
    @master_variant = Spree::Variant.find_by( sku: @product.sku )
  end


  def export_data_to_csv_file
    add_product_taxons
    add_master_variant_images
    add_product_properties
    add_master_variant_stockitem
    add_product_variants
  end

  def add_product_taxons
    @product.taxons.each do |taxon|

      @csv << [ @product.slug, @product.name, @product.description, @product.sku, @product.meta_title, @product.meta_keywords, @product.meta_description,
                @published, (@product.available_on).to_s, @discontinue, (@product.discontinue_on).to_s, (@product.price).to_s, ( @product.promotionable ).to_s,
                taxon.permalink, taxon.name, '', '', '', 0, '', 'default', '',
                '', '', '', @master_variant.weight, @master_variant.height, @master_variant.depth, @master_variant.width
             ]
    end
  end

  def add_master_variant_images
    @master_variant.images.each do |productvariant_image|

      @csv << [ @product.slug, @product.name, @product.description, @product.sku, @product.meta_title, @product.meta_keywords, @product.meta_description,
                @published, (@product.available_on).to_s, @discontinue, ( @product.discontinue_on ).to_s, ( @product.price ).to_s, ( @product.promotionable ).to_s,
                '', '', '', '', '', 0, '', 'default', @master_variant.sku, ( @master_variant.cost_price ).to_s, productvariant_image.url(:original),
                productvariant_image.alt, @master_variant.weight, @master_variant.height, @master_variant.depth, @master_variant.width
             ]
    end
  end

  def add_product_properties
    @product.product_properties.each do |property|

      @csv << [ @product.slug, @product.name, @product.description, @product.sku, @product.meta_title, @product.meta_keywords, @product.meta_description,
                @published, (@product.available_on).to_s, @discontinue, ( @product.discontinue_on ).to_s, ( @product.price ).to_s, ( @product.promotionable ).to_s,
                '', '', Spree::Property.find_by( id: property.property_id ).name, property.value, '', 0, '', 'default', '', '',
                '', '', @master_variant.weight, @master_variant.height, @master_variant.depth, @master_variant.width
             ]
    end
  end

  def add_master_variant_stockitem
    @master_variant.stock_items.each do |productvariant_stockitem|


      @csv << [ @product.slug, @product.name, @product.description, @product.sku, @product.meta_title, @product.meta_keywords, @product.meta_description,
                @published,(@product.available_on).to_s, @discontinue, ( @product.discontinue_on ).to_s, ( @product.price ).to_s, ( @product.promotionable ).to_s,
                '', '', '', '', '', productvariant_stockitem.count_on_hand, productvariant_stockitem.backorderable, Spree::StockLocation.find_by( id: productvariant_stockitem.stock_location_id ).name,
                @master_variant.sku, ( @master_variant.cost_price ).to_s, '', '', @master_variant.weight, @master_variant.height, @master_variant.depth, @master_variant.width
             ]
    end
  end

  def add_product_variants
    @product.variants.each do |variant|
      @variant = variant
      add_variant_stockitem
      add_variant_option_values
    end
  end

  def add_variant_stockitem
    @variant.stock_items.each do |stock_item|

      @csv << [ @product.slug, @product.name, @product.description, @product.sku, @product.meta_title, @product.meta_keywords, @product.meta_description,
                @published, (@product.available_on).to_s, @discontinue, (@product.discontinue_on).to_s, (@product.price).to_s, (@product.promotionable).to_s, '',
                '', '', '', '', stock_item.count_on_hand, stock_item.backorderable, Spree::StockLocation.find_by( id: stock_item.stock_location_id ).name,
                @variant.sku, ( @variant.cost_price ).to_s, '', '', @variant.weight, @variant.height, @variant.depth, @variant.width
             ]
    end
  end

  def add_variant_option_values
    @variant.option_values.each_with_index do |option_value, index|

      if option_value.equal?(@variant.option_values.last)
        @csv << [ @product.slug, @product.name, @product.description, @product.sku, @product.meta_title, @product.meta_keywords, @product.meta_description,
                  @published, (@product.available_on).to_s, @discontinue, (@product.discontinue_on).to_s, ( @product.price ).to_s, ( @product.promotionable ).to_s,
                  '', '', '', '', '', @variant.stock_items.last.count_on_hand, @variant.stock_items.last.backorderable, Spree::StockLocation.find_by( id: @variant.stock_items.last.stock_location_id ).name,
                  @variant.sku, (@variant.cost_price).to_s, index.present? && @variant.images[index].present? ? @variant.images[index].url(:original) : '',
                  index.present? && @variant.images[index].present? ? @variant.images[index].alt : '', @variant.weight, @variant.height,
                  @variant.depth, @variant.width, Spree::OptionType.find_by( id: option_value.option_type_id ).name, option_value.name, option_value.presentation
                ]
      else
        @csv << [ @product.slug, @product.name, @product.description, @product.sku, @product.meta_title, @product.meta_keywords, @product.meta_description,
                  @published, (@product.available_on).to_s, @discontinue, (@product.discontinue_on).to_s, ( @product.price ).to_s, ( @product.promotionable ).to_s, '',
                  '', '', '', '', 0, '', 'default', @variant.sku, (@variant.cost_price).to_s, index.present? && @variant.images[index].present? ? @variant.images[index].url(:original) : '',
                  index.present? && @variant.images[index].present? ? @variant.images[index].alt : '', @variant.weight, @variant.height,
                  @variant.depth, @variant.width, Spree::OptionType.find_by( id: option_value.option_type_id ).name, option_value.name, option_value.presentation
                ]
      end
    end
  end
end

# touched on 2025-05-22T20:31:34.775208Z
# touched on 2025-05-22T20:45:02.972716Z
# touched on 2025-05-22T22:34:16.341217Z
# touched on 2025-05-22T23:37:28.710654Z
# touched on 2025-06-13T21:17:20.652933Z