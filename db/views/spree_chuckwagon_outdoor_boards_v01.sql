SELECT "spree_products".*
FROM "spree_avaliable_products" AS "spree_products"
INNER JOIN "spree_labels_products" ON "spree_labels_products"."product_id" = "spree_products"."id"
INNER JOIN "spree_labels" ON "spree_labels"."id" = "spree_labels_products"."label_id"
WHERE "spree_labels"."tag" = 'Chuckwagon Outdoor Boards'
ORDER BY "spree_labels_products"."position" ASC

# touched on 2025-05-22T19:16:20.287405Z
# touched on 2025-05-22T20:32:55.137742Z
# touched on 2025-05-22T20:44:16.570482Z
# touched on 2025-05-22T20:45:06.775828Z
