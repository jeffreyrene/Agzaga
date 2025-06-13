module NetSuite
  class EbaySalesOrder < Base

    def initialize
      super
      @query_url = 'https://6983452.suitetalk.api.netsuite.com/services/rest/query/v1/suiteql'
      @sales_order_root = 'https://6983452.suitetalk.api.netsuite.com/services/rest/record/v1/salesOrder/'
    end

    def create(order_id, ebay_order_data)
      @order_data = ebay_order_data
      url = URI(@sales_order_root)

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request['Content-Type'] = 'application/json'

      request.body = JSON.dump(prepare_data(order_id))

      request['Authorization'] = "Bearer #{@access_token}"
      response = https.request(request)

      if response.code == '401' && @access_token_exp.past?
        refersh_token(:create, order_id)
      elsif response.code == '204'
        true
        add_NS_log(response.code, "Ebay: #{order_id} created successfully")
      else
        log_error_and_notify_admin( response, "Ebay: #{order_id} Can not create sales order: #{response.read_body}")
      end
    end

    def prepare_data(order_id)
      data = {
        entity: {id: 101396},
        otherRefNum: "eBay: #{order_id}",
        item: {
          items: prepare_items_for_order(order_id)
        },
        location: { id: 6 },
        customForm: { id: 182 },
        shippingAddress: prepare_address,
        shippingCost: @order_data['pricingSummary']['deliveryCost']['value'].to_f,
        shipMethod: { id: 615 },
        billingAddress: prepare_bill_address,
        custbody_ajs_ebayorderbox: true,
        trandate: @order_data['creationDate'],
        paymentmethod: { id: 8 },
        isCrossSubTransaction: true
      }
    end


    def prepare_items_for_order(order_id)
      res = get_items_ids(@order_data['lineItems'].map {|item| item['sku']}, order_id)

      data = @order_data['lineItems'].each_with_index.map do |lineItem|
        [{
          item:
            { id: res.find{|i| i[:sku] == lineItem['sku']}[:id] },
            rate: lineItem['total']['value'].to_f / lineItem['quantity'],
            quantity: lineItem['quantity'],
            price: { id: -1},
            inventorylocation: { id: 3 }
        }]
      end
      data.push({
        item:
          { id: "14836" },
            rate: -(@order_data['totalMarketplaceFee']['value'].to_f),
            quantity: 1,
            inventorylocation: { id: 6 }
      })
      data.flatten
    end

    def get_items_ids(sku_list, order_id)
      url = URI(@query_url)

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(url)
      request["prefer"] = "transient"
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{ @access_token }"

      query_data = sku_list.map {|item| "'#{item}'" }.join(',')

      request.body = JSON.dump({
        "q": "SELECT id, itemid FROM item WHERE itemid IN (#{query_data})"
      })

      response = https.request(request)

      if response.code == '401' && @access_token_exp.past?
        refersh_token(:get_items_ids, sku_list, order_id)
      elsif response.code == '200'
        res = JSON.parse response.read_body
        if res['count'] == 0
          log_error_and_notify_admin(response, "Ebay: #{order_id} No product found on net suite")
        elsif res['count'] != sku_list.count
          log_error_and_notify_admin(response, "Ebay: #{order_id} Some product SKU not found on net suite")
        else
          add_NS_log(response.code, "Ebay: #{order_id} Fetched items ids successfully")
          res['items'].map{|i| {id: i['id'], sku: i['itemid']}}
        end
      else
        log_error_and_notify_admin( response, "Ebay: #{order_id} #{response.read_body}")
      end
    end

    def prepare_address
      address = @order_data['fulfillmentStartInstructions'][0]['shippingStep']['shipTo']
        {
          addr1: address['contactAddress']['addressLine1'],
          city: address['contactAddress']['city'],
          country: { id: 'US' },
          state: address['contactAddress']['stateOrProvince'],
          zip: address['contactAddress']['postalCode'],
          attention: address['fullName'],
          addressee: address['primaryPhone']['phoneNumber'],
          isResidential: true
        }
    end

    def prepare_bill_address
      address = @order_data['fulfillmentStartInstructions'][0]['shippingStep']['shipTo']
        {
          addr1: address['contactAddress']['addressLine1'],
          city: address['contactAddress']['city'],
          country: { id: 'US' },
          state: address['contactAddress']['stateOrProvince'],
          zip: address['contactAddress']['postalCode']
        }
    end
  end
end

# touched on 2025-05-22T23:30:24.319216Z
# touched on 2025-05-22T23:41:49.646453Z
