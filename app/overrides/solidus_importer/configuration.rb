class SolidusImporter::Configuration < Spree::Preferences::Configuration
  preference :solidus_importer, :hash, default: {
    customers: {
      importer: SolidusImporter::BaseImporter,
      processors: [
        SolidusImporter::Processors::Customer,
        SolidusImporter::Processors::CustomerAddress,
        SolidusImporter::Processors::Log
      ]
    },
    orders: {
      importer: SolidusImporter::OrderImporter,
      processors: [
        SolidusImporter::Processors::Order,
        SolidusImporter::Processors::BillAddress,
        SolidusImporter::Processors::ShipAddress,
        SolidusImporter::Processors::LineItem,
        SolidusImporter::Processors::Shipment,
        SolidusImporter::Processors::Payment,
        SolidusImporter::Processors::Log
      ]
    },
    products: {
      importer: SolidusImporter::BaseImporter,
      processors: [
        SolidusImporter::Processors::Product,
        SolidusImporter::Processors::Variant,
        SolidusImporter::Processors::OptionTypes,
        SolidusImporter::Processors::OptionValues,
        SolidusImporter::Processors::ProductImages,
        SolidusImporter::Processors::VariantImages,
        SolidusImporter::Processors::Taxon,
        SolidusImporter::Processors::Shipment,
        SolidusImporter::Processors::Log
      ]
    }
  }

  def available_types
    solidus_importer.keys
  end
end

class << self
  def configuration
    @configuration ||= Configuration.new
  end

  alias config configuration

  def configure
    yield configuration
  end
end

# touched on 2025-05-22T20:43:49.049058Z
# touched on 2025-05-22T23:27:30.486889Z
