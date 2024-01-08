SELECT "spree_products".*
FROM "spree_avaliable_products" AS "spree_products"
INNER JOIN "spree_labels_products" ON "spree_labels_products"."product_id" = "spree_products"."id"
INNER JOIN "spree_labels" ON "spree_labels"."id" = "spree_labels_products"."label_id"
WHERE "spree_labels"."tag" = 'Chuckwagon Pre Order'
ORDER BY "spree_labels_products"."position" ASC

# touched on 2025-05-22T22:34:18.675420Z
# touched on 2025-05-22T22:38:54.964927Z
# touched on 2025-05-22T23:19:03.677540Z
# touched on 2025-05-22T23:28:02.020743Z
# touched on 2025-05-22T23:37:02.270457Z
# touched on 2025-06-13T21:14:31.226554Z