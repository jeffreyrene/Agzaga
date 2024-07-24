Spree.Views.Stock.EditStockItemRow = Backbone.View.extend({
  tagName: 'tr',

  initialize: function(options) {
    this.stockLocationName = options.stockLocationName;
    this.stockLocationId = options.stockLocationId;
    this.variantSku = options.variantSku;
    this.negative = this.model.attributes.count_on_hand < 0;
    this.previousAttributes = _.clone(this.model.attributes);
    this.listenTo(this.model, 'sync', this.onSuccess);
    this.render();
  },

  events: {
    "click .submit": "onSubmit",
    "submit form": "onSubmit",
    "click .cancel": "onCancel",
    'input [name="count_on_hand"]': "countOnHandChanged",
    'input [name="max_stock"]': "maxStockChanged",
    'input [name="backorderable"]': "backorderableChanged"
  },

  template: HandlebarsTemplates['stock_items/stock_location_stock_item'],

  render: function() {
    var renderAttr = {
      stockLocationName: this.stockLocationName,
      stockLocationId: this.stockLocationId,
      variantSku: this.variantSku,
      editing: this.editing,
      negative: this.negative
    };
    _.extend(renderAttr, this.model.attributes);
    this.$el.attr("data-variant-id", this.model.get('variant_id'));
    this.$el.html(this.template(renderAttr));
    this.$count_on_hand_display = this.$('.count-on-hand-display');
    this.$max_stock_display = this.$('.max-stock-display');
    return this;
  },

  onEdit: function(ev) {
    ev.preventDefault();
    this.render();
  },

  onCancel: function(ev) {
    ev.preventDefault();
    this.model.set(this.previousAttributes);
    this.$el.removeClass('changed');
    this.render();
  },

  onChange: function() {
    var count_on_hand_changed = this.previousAttributes.count_on_hand != this.model.attributes.count_on_hand;
    var backorderable_changed = this.previousAttributes.backorderable != this.model.attributes.backorderable;
    var max_stock_changed = this.previousAttributes.max_stock != this.model.attributes.max_stock;
    var changed = count_on_hand_changed || backorderable_changed || max_stock_changed;

    this.$el.toggleClass('changed', changed);
  },

  backorderableChanged: function(ev) {
    this.model.set("backorderable", ev.target.checked);

    this.onChange();
  },

  countOnHandChanged: function(ev) {
    var diff = parseInt(ev.currentTarget.value), newCount;
    if (isNaN(diff)) diff = 0;
    newCount = this.previousAttributes.count_on_hand + diff;
    ev.preventDefault();
    // Do not allow negative stock values
    if (newCount < 0) {
      ev.currentTarget.value = -1 * this.previousAttributes.count_on_hand;
      this.$count_on_hand_display.text(0);
    } else {
      this.model.set("count_on_hand", newCount);
      this.$count_on_hand_display.text(newCount);
    }

    this.onChange();
  },

  maxStockChanged: function(ev) {
    var newCount = parseInt(ev.currentTarget.value);
    this.model.set("max_stock", newCount);
    this.$max_stock_display.text(newCount);
    this.onChange();
  },

  onSuccess: function() {
    this.$el.removeClass('changed');
    this.previousAttributes = _.clone(this.model.attributes);
    this.render();
    this.$('[name="count_on_hand"]').focus();
  },

  onError: function(model, response, options) {
    if ('{"error":"Not enough stock found for group product"}' == response.responseText) {
      this.$count_on_hand_display.text(this.previousAttributes.count_on_hand);
    }
    show_flash("error", response.responseText);
  },

  onSubmit: function(ev) {
    ev.preventDefault();
    var backorderable = this.$('[name=backorderable]').prop("checked");
    var countOnHand = parseInt(this.$("input[name='count_on_hand']").val(), 10);
    var maxstock = parseInt(this.$("input[name='max_stock']").val(), 10);

    this.model.set({
      count_on_hand: countOnHand,
      backorderable: backorderable,
      max_stock: maxstock
    });
    var options = {
      success: function() {
        show_flash("success", Spree.translations.updated_successfully);
      },
      error: this.onError.bind(this)
    };
    this.model.save({}, options);
  }
});

# touched on 2025-05-22T19:09:25.638707Z
# touched on 2025-05-22T19:10:22.703273Z
# touched on 2025-05-22T20:38:16.642941Z
# touched on 2025-05-22T20:45:04.829044Z
# touched on 2025-05-22T22:33:52.790422Z
# touched on 2025-05-22T22:55:01.289730Z
# touched on 2025-05-22T23:43:35.160593Z
# touched on 2025-06-13T21:18:04.241565Z