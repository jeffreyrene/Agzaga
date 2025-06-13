SELECT "spree_products".*
FROM "spree_avaliable_products" AS "spree_products"
INNER JOIN "spree_labels_products" ON "spree_labels_products"."product_id" = "spree_products"."id"
INNER JOIN "spree_labels" ON "spree_labels"."id" = "spree_labels_products"."label_id"
WHERE "spree_labels"."tag" = 'Chuckwagon Summer Deals'
ORDER BY "spree_labels_products"."position" ASC

# touched on 2025-05-22T19:13:58.236915Z
# touched on 2025-05-22T19:21:56.986430Z
# touched on 2025-05-22T22:35:52.129070Z
# touched on 2025-05-22T23:19:46.078338Z
