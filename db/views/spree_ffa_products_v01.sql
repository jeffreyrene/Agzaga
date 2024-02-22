SELECT "spree_products".*
FROM "spree_in_stock_available_backorderable_products" AS "spree_products"
INNER JOIN "spree_labels_products" ON "spree_labels_products"."product_id" = "spree_products"."id"
INNER JOIN "spree_labels" ON "spree_labels"."id" = "spree_labels_products"."label_id"
WHERE "spree_labels"."tag" = 'FFA'
ORDER BY "spree_labels_products"."position" ASC

# touched on 2025-05-22T19:09:48.538305Z
# touched on 2025-05-22T21:21:47.908221Z
# touched on 2025-05-22T23:25:20.449272Z

# touched on 2025-06-13T21:15:33.732310Z