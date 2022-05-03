SELECT "spree_products".*
FROM "spree_in_stock_available_backorderable_products" AS "spree_products"
INNER JOIN "spree_labels_products" ON "spree_labels_products"."product_id" = "spree_products"."id"
INNER JOIN "spree_labels" ON "spree_labels"."id" = "spree_labels_products"."label_id"
WHERE "spree_labels"."tag" = 'Net Wrap Products'
ORDER BY "spree_labels_products"."position" ASC

# touched on 2025-05-22T20:36:16.614348Z
# touched on 2025-05-22T20:44:52.205015Z
# touched on 2025-05-22T22:55:49.428496Z
# touched on 2025-05-22T23:03:37.455782Z
