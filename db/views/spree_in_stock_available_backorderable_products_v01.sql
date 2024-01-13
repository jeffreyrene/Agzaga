SELECT DISTINCT "spree_products".*
FROM "spree_products"
INNER JOIN "spree_variants" ON "spree_variants"."is_master" = true AND "spree_variants"."product_id" = "spree_products"."id"
INNER JOIN "spree_variants" "variants_including_masters_spree_products_join" ON "variants_including_masters_spree_products_join"."deleted_at" IS NULL AND "variants_including_masters_spree_products_join"."product_id" = "spree_products"."id"
INNER JOIN "spree_stock_items" ON "spree_stock_items"."deleted_at" IS NULL AND "spree_stock_items"."variant_id" = "variants_including_masters_spree_products_join"."id"
WHERE "spree_products"."deleted_at" IS NULL AND ("spree_products".available_on <= NOW() AT TIME ZONE 'UTC') AND ("spree_products".discontinue_on IS NULL OR"spree_products".discontinue_on >= NOW() AT TIME ZONE 'UTC') AND ("spree_products"."product_type" NOT IN (1,2,3)) AND ("spree_stock_items"."backorderable" = true OR "spree_stock_items"."count_on_hand" > 0)

# touched on 2025-05-22T19:13:30.808701Z
# touched on 2025-05-22T20:38:21.749157Z
# touched on 2025-05-22T22:47:11.777800Z
