module Models
  module Spree
    module ProductDecorator
      def self.prepended(base)
        base.class_eval do
          include TimeZoneVariation

          has_one :product_card
          has_many :product_questions
          has_many :labels_products
          has_many :labels, through: :labels_products, dependent: :destroy
          accepts_nested_attributes_for :labels
          before_save -> { time_zone_variation(:available_on, :discontinue_on) }, if: -> { self.changed? }
          after_save :product_card_job
          after_touch :product_card_job
          after_commit :notify_google_indexing

          has_and_belongs_to_many :filter_types, dependent: :destroy, inverse_of: :product
          has_and_belongs_to_many :filter_values, dependent: :destroy, inverse_of: :product

          scope :sale_products, -> { joins(:sale_prices).where("spree_sale_prices.enabled = true").
                                     where('(spree_sale_prices.start_at <= ? OR spree_sale_prices.start_at IS NULL) AND (spree_sale_prices.end_at >= ? OR spree_sale_prices.end_at IS NULL)', Time.now, Time.now)}
          scope :sale_products_sort, -> {select("spree_products.*").joins("LEFT OUTER JOIN (#{sale_products.to_sql}) AS p ON spree_products.id = p.id").order("p.id")}
          scope :product_cards_with_expired_sale, -> (product_ids) { joins(:product_card).
                                     where('(spree_products.id IN (?) AND spree_product_cards.sale_ends_at <= ? )', product_ids, Time.now)}
          scope :newest_products, -> { order('spree_products.available_on DESC') }
          scope :deal_prodcuts, -> (tag){ available.includes(:labels).where(spree_labels: { tag: tag })}
          scope :staff_pick_position, -> {select('spree_products.*, spree_labels_products.position AS staff_pick_position, 1 as staff_pick').
                                            joins(:labels).where(spree_labels: { tag: "Staff Pick" })}
          scope :staff_pick_sort, -> {available.select("spree_products.*").joins("LEFT OUTER JOIN (#{staff_pick_position.to_sql}) AS p ON spree_products.id = p.id").order("p.staff_pick, p.staff_pick_position")}

          scope :featured_products, -> { available.includes(:labels).where(spree_labels: { tag: "Featured Products" })}
          scope :ffa_products, -> { available.includes(:labels).where(spree_labels: { tag: "FFA" })}
          scope :in_stock, -> { joins(:stock_items).where("spree_stock_items.count_on_hand > ? OR spree_stock_items.backorderable = ?",0,true).distinct }
          scope :best_sellers_variant_vise, -> { available.select("spree_products.id as p_id, SUM(spree_line_items.quantity) as total_qty, spree_line_items.variant_id").
                                  joins(:line_items).joins("INNER JOIN spree_orders ON spree_orders.id = spree_line_items.order_id").
                                  where("spree_orders.completed_at IS NOT NULL AND spree_products.product_type NOT IN (1,2,3)").
                                  group("spree_line_items.variant_id, spree_products.id")}
          scope :best_sellers, -> { available.includes(:labels).where(spree_labels: { tag: "Best Seller Products" }).merge(in_stock)}
          scope :best_sellers_position, -> { available.select("spree_products.*, coalesce(cast(nullif(SUM(p.total_qty),0) as float),0) as sold_qty").
                                  from( "spree_products LEFT OUTER JOIN (#{best_sellers_variant_vise.to_sql}) AS p ON spree_products.id = p.p_id").
                                  group("spree_products.id").order('sold_qty DESC')}
          scope :best_sellers_sort, -> { available.select("spree_products.*, q.sold_qty").
                                  from( "spree_products LEFT OUTER JOIN (#{best_sellers_position.to_sql}) AS q ON spree_products.id = q.id").order(Arel.sql("q.sold_qty DESC"))}

          scope :exclude_custom_products, -> { where("spree_products.product_type NOT IN (1,2,3)")}
          scope :order_products_desc, -> (tag){ available.includes(:labels).where(spree_labels: { tag: tag } )
                                  .joins(:sale_prices)
                                  .where('spree_sale_prices.enabled = true')
                                  .where('(spree_sale_prices.start_at <= ? OR spree_sale_prices.start_at IS NULL) AND (spree_sale_prices.end_at >= ? OR spree_sale_prices.end_at IS NULL)', Time.now, Time.now)
                                  .reorder("spree_sale_prices.value DESC")}

          scope :order_products_asc, -> (tag){ available.includes(:labels).where(spree_labels: { tag: tag } )
                                  .joins(:sale_prices)
                                  .where('spree_sale_prices.enabled = true')
                                  .where('(spree_sale_prices.start_at <= ? OR spree_sale_prices.start_at IS NULL) AND (spree_sale_prices.end_at >= ? OR spree_sale_prices.end_at IS NULL)', Time.now, Time.now)
                                  .reorder("spree_sale_prices.value ASC")}

          scope :featured_products_for_home, -> { available.includes(:labels).where(spree_labels: { tag: "Featured Products" }).order(:position)}
          scope :site_wide_deals_products_for_home, -> { available.includes(:labels).where(spree_labels: { tag: "Site Wide Deals" })}
          scope :start_young_products, -> { available.includes(:labels).where(spree_labels: { tag: "Start young" })}
          scope :make_it_easy_products, -> { available.includes(:labels).where(spree_labels: { tag: "Make easy" })}

          scope :sort_by_price, -> (price) { available.joins(:prices).where("spree_prices.amount < ?", price)}
          scope :sort_by_greater_than_price, -> (price) { available.joins(:prices).where("spree_prices.amount > ?", price)}
          scope :sort_by_price_with_range, -> (lower_price, higher_price) { available.joins(:prices).where("spree_prices.amount BETWEEN ? AND ?", lower_price, higher_price)}
          scope :without_facebook_id, -> {available.where(facebook_id: nil)}
        end

        def product_card_job
          CreateUpdateProductCardJob.perform_later(self.id)
        end

        def create_or_update_product_card
          image_url = card_image_url

          label = card_label
          label_text = label[:display_text] if label.present?
          label_color = label[:color] if label.present?
          label_display_text_color = label[:display_text_color] if label.present?

          discount_percentage = self.discount_percent.round
          in_stock = in_stock?

          before_sale_price = self.original_price if self.on_sale?
          sale_ends_at = self.sale_prices.active.order("created_at DESC").first&.end_at&.to_datetime if self.sale_prices&.active.present?

          self.build_product_card unless self.product_card
          self.product_card.update(name: self.name, slug: self.slug, image_url: image_url, original_price: before_sale_price, price: self.price, on_sale: self.on_sale?, in_stock: in_stock,
                                   label_text: label_text, label_color: label_color, sale_ends_at: sale_ends_at, label_display_text_color: label_display_text_color, discount_percentage: discount_percentage)
        end

        def card_image_url
          images = self.gallery&.images
          return nil unless images.present?

          images.where(alt: "mobile-image")&.first&.url(:sm_285) || images&.first&.url(:sm_285)
        end

        def in_stock?
          variants.present? ? variants.any?{ |v| v.can_supply? } : master.can_supply?
        end

        def out_of_stock?
          !in_stock?
        end

        def card_label
          labels_map = {}
          self.labels.pluck(:tag, :display_text, :color, :display_text_color).each do |key, value, color, display_text_color|
            labels_map[key] = value
            labels_map[key + '_color'] = color.present? ? color : '#FFB514'
            labels_map[key + '_display_text_color'] = display_text_color.present? ? display_text_color : '#FFFFFF'
          end

          if labels_map.key? 'Staff Pick'
            display_text = labels_map['Staff Pick'].present? ? labels_map['Staff Pick'] : 'Staff Pick'

            if (!variants.present? && master.is_dropship == true) || variants.any? { |v| v.is_dropship == true }
              display_text = "#{display_text},Ships Direct"
            end
            { display_text: display_text, color: labels_map['Staff Pick_color'], display_text_color: labels_map['Staff Pick_display_text_color'] }
          elsif (!variants.present? && master.volume_prices.present?) || variants.any? {|v| v.volume_prices.present?}
            if (!variants.present? && master.is_dropship == true) || variants.any? { |v| v.is_dropship == true }
              display_text = "Bulk Price Available,Ships Direct"
            else
              display_text = "Bulk Price Available"
            end
            { display_text: display_text, color: '#FFB514', display_text_color: '#FFFFFF' }
          elsif (!variants.present? && master.is_dropship == true) || variants.any? { |v| v.is_dropship == true }
            { display_text: "Ships Direct", color: '#FFB514', display_text_color: '#FFFFFF' }
          end
        end

        def deal_product?
          self.labels.pluck(:tag).include? "Deals"
        end

        def staff_choice_product?
          self.labels.pluck(:tag).include? "Staff Pick"
        end

        def total_discount
          (self.original_price - self.sale_price).to_i if self.on_sale?
        end

        def notify_google_indexing
          url_type = discarded? ? 'URL_DELETED' : 'URL_UPDATED'
          GoogleIndexingJob.perform_later(self.slug, url_type) if ENV['INDEXING_API_INTEGRATION'] == 'Active'
        end
      end

      ::Spree::Product.prepend self
    end
  end
end
