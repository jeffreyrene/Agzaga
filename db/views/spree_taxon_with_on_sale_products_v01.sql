SELECT DISTINCT "spree_taxons".*
FROM "spree_taxons"
  INNER JOIN "spree_products_taxons"
    ON "spree_taxons"."id" = "spree_products_taxons"."taxon_id"
  INNER JOIN "spree_products"
    ON "spree_products_taxons"."product_id" = "spree_products"."id"
  INNER JOIN "spree_variants"
    ON "spree_variants"."is_master" = true AND "spree_variants"."product_id" = "spree_products"."id"
  INNER JOIN "spree_variants" "variants_including_masters_spree_products_join"
    ON "variants_including_masters_spree_products_join"."deleted_at" IS NULL AND "variants_including_masters_spree_products_join"."product_id" = "spree_products"."id"
  INNER JOIN "spree_prices"
    ON "spree_prices"."deleted_at" IS NULL AND "spree_prices"."variant_id" = "variants_including_masters_spree_products_join"."id"
  INNER JOIN "spree_sale_prices"
    ON "spree_sale_prices"."deleted_at" IS NULL AND "spree_sale_prices"."price_id" = "spree_prices"."id"
WHERE "spree_products"."deleted_at" IS NULL AND EXISTS (SELECT "spree_prices".* FROM "spree_prices"
WHERE "spree_prices"."deleted_at" IS NULL AND "spree_variants"."id" = "spree_prices"."variant_id")
  AND ("spree_products".available_on <= (now() at time zone 'utc'))
  AND ("spree_products".discontinue_on IS NULL OR"spree_products".discontinue_on >= (now() at time zone 'utc'))
  AND (spree_sale_prices.enabled = true)
  AND ((spree_sale_prices.start_at <= (now() at time zone 'utc') OR spree_sale_prices.start_at IS NULL)
  AND (spree_sale_prices.end_at >= (now() at time zone 'utc') OR spree_sale_prices.end_at IS NULL))
ORDER BY "spree_taxons"."taxonomy_id", "spree_taxons"."parent_id", "spree_taxons"."lft";

# touched on 2025-05-22T20:36:22.577481Z
# touched on 2025-05-22T23:07:03.429344Z
# touched on 2025-05-22T23:19:27.091216Z
# touched on 2025-06-13T21:21:47.451054Z