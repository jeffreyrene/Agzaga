SELECT spree_on_sale_products.* FROM (SELECT DISTINCT "spree_products".*, "spree_sale_prices".calculated_price
FROM "spree_products"
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
  AND (spree_sale_prices.end_at >= (now() at time zone 'utc') OR spree_sale_prices.end_at IS NULL))) AS spree_on_sale_products

    LEFT JOIN (SELECT spree_on_sale_products.id, spree_labels_products.position AS staff_pick_position
      FROM spree_on_sale_products
    LEFT OUTER JOIN spree_labels_products
      ON spree_labels_products.product_id = spree_on_sale_products.id
    LEFT OUTER JOIN spree_labels
      ON spree_labels.id = spree_labels_products.label_id
  WHERE spree_labels.tag = 'Staff Pick' ORDER BY spree_labels_products.position) AS p
ON spree_on_sale_products.id = p.id ORDER BY staff_pick_position, p.id;

# touched on 2025-05-22T22:31:23.198046Z
# touched on 2025-05-22T23:18:36.122653Z
