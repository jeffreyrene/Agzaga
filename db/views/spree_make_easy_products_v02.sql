SELECT "spree_products".*
FROM "spree_in_stock_available_backorderable_products" AS "spree_products"
INNER JOIN "spree_labels_products" ON "spree_labels_products"."product_id" = "spree_products"."id"
INNER JOIN "spree_labels" ON "spree_labels"."id" = "spree_labels_products"."label_id"
WHERE "spree_labels"."tag" = 'Make easy'

# touched on 2025-05-22T21:30:45.112293Z
# touched on 2025-06-13T21:19:25.995702Z
# touched on 2025-06-13T21:22:12.982978Z