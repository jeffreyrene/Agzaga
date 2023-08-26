class SolidusImporter::Processors::OptionValues < SolidusImporter::Processors::Base
  attr_accessor :option_types, :variant

  def call( context )
    @data = context.fetch( :data )
    return unless option_values?

    self.variant = context.fetch( :variant )
    process_option_values
  end

  private

  def process_option_values
    option_value_names.each_with_index do |name, index|
      next if name.empty?
      option_value = Spree::OptionValue.find_or_initialize_by(
        option_type: option_type(index),
        name: name
      )
      option_value.presentation = @data['Option' + (index+1).to_s + ' Presentation']
      option_value.save!
      variant.option_values << option_value unless variant.option_values.include?( option_value )
      variant.save!
    end
  end

  def option_type( index )
    variant.product.option_types.find { |ot| ot.position == index + 1 }
  end

  def option_value_names
    @option_value_names ||= @data.values_at(
      'Option1 Value',
      'Option2 Value',
      'Option3 Value'
    ).compact
  end

  def option_values?
    # NOTE: according to https://help.shopify.com/en/manual/products/import-export
    # when `Option Value1` is equal to 'Default Title`, means that product has no
    # variants.
    ( @data[ 'Option1 Value' ] != 'Default Title' ) && option_value_names.any?
  end
end

# touched on 2025-05-22T19:19:05.967798Z
# touched on 2025-05-22T19:22:33.477977Z
# touched on 2025-05-22T20:38:05.165708Z
# touched on 2025-05-22T22:51:23.577644Z
