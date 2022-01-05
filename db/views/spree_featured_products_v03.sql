SELECT "spree_products".*
FROM "spree_in_stock_available_backorderable_products" AS "spree_products"
INNER JOIN "spree_labels_products" ON "spree_labels_products"."product_id" = "spree_products"."id"
INNER JOIN "spree_labels" ON "spree_labels"."id" = "spree_labels_products"."label_id"
WHERE "spree_labels"."tag" = 'Featured Products'
ORDER BY "spree_labels_products"."position" ASC

# touched on 2025-05-22T19:07:39.278349Z
# touched on 2025-05-22T20:34:25.209584Z
# touched on 2025-05-22T22:45:44.588255Z
# touched on 2025-05-22T23:22:28.625441Z
