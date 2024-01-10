class SolidusImporter::Processors::Product < SolidusImporter::Processors::Base
  def call( context )
    @data = context.fetch( :data )
    check_data
    context.merge!( product: process_product )
  end

  def options
    @options ||= {
      available_on: Date.current.yesterday,
      not_available: nil,
      price: 0,
      shipping_category: Spree::ShippingCategory.find_by( name: 'Default' ) || Spree::ShippingCategory.first
    }
  end

  private

  def check_data
    raise SolidusImporter::Exception, 'Missing required key: "Handle"' if @data[ 'Handle' ].blank?
  end

  def prepare_product
    Spree::Product.find_or_initialize_by( slug: @data[ 'Handle' ] )
  end

  def process_product
    prepare_product.tap do |product|
      product.slug = @data[ 'Handle' ]
      product.price = @data[ 'Price' ]
      product.description = @data[ 'description' ]
      product.sku = @data[ 'SKU' ]
      product.meta_title = @data['Meta Title']
      product.meta_keywords = @data['Meta Keywords']
      product.meta_description = @data['Meta Description']
      product.discontinue_on = @data[ 'Discontinue At' ] if discontinue?
      product.available_on = available? ? @data[ 'Published At' ] : options[ :not_available ]
      product.shipping_category = options[ :shipping_category ]
      product.promotionable = @data[ 'Promotionable' ]
      product.name = @data[ 'Title' ] unless @data[ 'Title' ].nil?

      if @data[ 'Property Name' ].present?
        property = Spree::Property.create_with(presentation: @data[ 'Property Name' ]).find_or_create_by( name: @data['Property Name'] )
        product.properties <<  property unless product.properties.include?( property )
      end

      product.save!

      if @data[ 'Property Value' ]
        product_property = Spree::ProductProperty.where( product: product, property: property ).first_or_initialize
        product_property.value = @data[ 'Property Value' ]
        product_property.save!
      end
    end
  end

  def available?
    @data[ 'Published' ].downcase == 'true'
  end

  def discontinue?
    @data[ 'Discontinue' ].downcase == 'true'
  end
end

# touched on 2025-05-22T22:45:03.949227Z
# touched on 2025-05-22T22:45:09.644874Z
# touched on 2025-05-22T23:01:49.467345Z
# touched on 2025-05-22T23:30:24.323897Z
# touched on 2025-06-13T21:14:47.281381Z