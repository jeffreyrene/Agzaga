SELECT "spree_products".*
FROM "spree_avaliable_products" AS "spree_products"
INNER JOIN "spree_labels_products" ON "spree_labels_products"."product_id" = "spree_products"."id"
INNER JOIN "spree_labels" ON "spree_labels"."id" = "spree_labels_products"."label_id"
WHERE "spree_labels"."tag" = 'Chuckwagon Outdoor Accessories'
ORDER BY "spree_labels_products"."position" ASC

# touched on 2025-05-22T19:23:39.107023Z
# touched on 2025-05-22T20:31:57.340331Z
# touched on 2025-05-22T20:35:29.993562Z
# touched on 2025-05-22T20:37:41.521768Z
