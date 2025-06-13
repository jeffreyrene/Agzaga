SELECT "spree_products".*
FROM "spree_in_stock_available_products" AS "spree_products"
INNER JOIN "spree_labels_products" ON "spree_labels_products"."product_id" = "spree_products"."id"
INNER JOIN "spree_labels" ON "spree_labels"."id" = "spree_labels_products"."label_id"
WHERE "spree_labels"."tag" = 'Make easy'

# touched on 2025-05-22T21:33:54.883678Z
# touched on 2025-05-22T22:32:30.482055Z
# touched on 2025-05-22T23:26:54.474491Z
