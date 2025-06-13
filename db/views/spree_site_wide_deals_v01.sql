SELECT "spree_products".*
FROM "spree_in_stock_available_products" AS "spree_products"
INNER JOIN "spree_labels_products" ON "spree_labels_products"."product_id" = "spree_products"."id"
INNER JOIN "spree_labels" ON "spree_labels"."id" = "spree_labels_products"."label_id"
WHERE "spree_labels"."tag" = 'Site Wide Deals'

# touched on 2025-05-22T20:44:23.606354Z
# touched on 2025-05-22T23:25:28.970158Z
# touched on 2025-05-22T23:46:03.098791Z
