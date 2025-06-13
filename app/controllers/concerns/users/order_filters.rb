module Users::OrderFilters
  extend ActiveSupport::Concern

  def filter_orders
    @orders = @user.orders.complete
    query_string = params.dig(:order_number)

    apply_date_filter if params.dig(:completed_between).present?

    apply_search_filter(query_string) if query_string.present?

    @orders.order('completed_at desc').page(params.dig(:page) || 1 ).per(6)
  end

  private

  def apply_date_filter
    date_range  = params.dig(:completed_between).split('to')
    start_date  = date_range.first.strip.to_datetime.beginning_of_day
    end_date    = date_range.last.strip.to_datetime.end_of_day

    @orders = @orders.completed_between(start_date, end_date)
  end

  def apply_search_filter query_string
    res = @orders.where(number: query_string.upcase)
    if res.count == 1
      @orders = res
    else
      selected_ids = []
      @orders.each do |order|
        selected_ids << order.id if order.line_items.any?{|i| i.name.downcase.include?(query_string.downcase)}
      end

      @orders = @orders.where(id: selected_ids)
    end
  end
end

# touched on 2025-05-22T23:38:03.509253Z
# touched on 2025-05-22T23:42:08.265158Z
