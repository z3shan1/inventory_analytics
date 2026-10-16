-- 03_bronze_load.sql
-- Loads the 12 source CSVs into bronze. Re-runnable: each table is truncated first.
--
-- BEFORE RUNNING: edit the folder path below if your CSVs live elsewhere.
-- Current path: D:/Service Manuals/EE/USB/Niche/Inventory Analysis/inventory_dataset/
--
-- COPY runs as the Postgres service account. If you get "permission denied",
-- run the \copy versions instead in pgAdmin's PSQL Tool (one line each, no trailing semicolon),
-- or move the CSVs to a folder Postgres can read.

TRUNCATE bronze.channel_master, bronze.item_master, bronze.item_supplier,
         bronze.location_master, bronze.movement_history, bronze.open_demand,
         bronze.open_supply, bronze.po_history, bronze.stock_on_hand,
         bronze.supplier_master, bronze.unit_cost, bronze.uom_conversion;

COPY bronze.channel_master (channel_id, channel_name, channel_type, country, fulfilment_location_id)
FROM 'D:/Service Manuals/EE/USB/Niche/Inventory Analysis/inventory_dataset/channel_master.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY bronze.item_master (sku_id, brand, category, subcategory, model_number, key_spec, item_type, base_uom, list_price_aed, lifecycle_status, criticality)
FROM 'D:/Service Manuals/EE/USB/Niche/Inventory Analysis/inventory_dataset/item_master.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY bronze.item_supplier (sku_id, supplier_id, is_primary, quoted_lead_time_days, moq_base_units, order_multiple_base_units, ship_uom)
FROM 'D:/Service Manuals/EE/USB/Niche/Inventory Analysis/inventory_dataset/item_supplier.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY bronze.location_master (location_id, location_name, country, city, location_type, transit_days_from_hub, status)
FROM 'D:/Service Manuals/EE/USB/Niche/Inventory Analysis/inventory_dataset/location_master.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY bronze.movement_history (movement_id, movement_date, sku_id, location_id, movement_type, quantity, uom, reason_code, doc_ref, counterparty_id)
FROM 'D:/Service Manuals/EE/USB/Niche/Inventory Analysis/inventory_dataset/movement_history.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY bronze.open_demand (order_id, order_date, required_date, sku_id, channel_id, fulfilment_location_id, open_qty, uom, status)
FROM 'D:/Service Manuals/EE/USB/Niche/Inventory Analysis/inventory_dataset/open_demand.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY bronze.open_supply (supply_ref, supply_type, sku_id, origin_id, destination_location_id, open_qty, uom, order_date, promised_date, status)
FROM 'D:/Service Manuals/EE/USB/Niche/Inventory Analysis/inventory_dataset/open_supply.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY bronze.po_history (po_id, sku_id, supplier_id, destination_location_id, order_date, promised_date, received_date, ordered_qty, received_qty, order_uom)
FROM 'D:/Service Manuals/EE/USB/Niche/Inventory Analysis/inventory_dataset/po_history.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY bronze.stock_on_hand (snapshot_date, sku_id, location_id, on_hand_qty, uom)
FROM 'D:/Service Manuals/EE/USB/Niche/Inventory Analysis/inventory_dataset/stock_on_hand.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY bronze.supplier_master (supplier_id, supplier_name, country, city, currency, payment_terms, status)
FROM 'D:/Service Manuals/EE/USB/Niche/Inventory Analysis/inventory_dataset/supplier_master.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY bronze.unit_cost (sku_id, effective_date, unit_cost_aed_per_base_unit, cost_basis, currency)
FROM 'D:/Service Manuals/EE/USB/Niche/Inventory Analysis/inventory_dataset/unit_cost.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY bronze.uom_conversion (sku_id, uom, factor_to_base, is_base)
FROM 'D:/Service Manuals/EE/USB/Niche/Inventory Analysis/inventory_dataset/uom_conversion.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Row-count check (expected: 13, 99, 115, 5, 8770, 486, 47, 355, 4098, 10, 129, 211)
SELECT 'channel_master' AS tbl, count(*) AS row_count FROM bronze.channel_master
UNION ALL SELECT 'item_master',      count(*) FROM bronze.item_master
UNION ALL SELECT 'item_supplier',    count(*) FROM bronze.item_supplier
UNION ALL SELECT 'location_master',  count(*) FROM bronze.location_master
UNION ALL SELECT 'movement_history', count(*) FROM bronze.movement_history
UNION ALL SELECT 'open_demand',      count(*) FROM bronze.open_demand
UNION ALL SELECT 'open_supply',      count(*) FROM bronze.open_supply
UNION ALL SELECT 'po_history',       count(*) FROM bronze.po_history
UNION ALL SELECT 'stock_on_hand',    count(*) FROM bronze.stock_on_hand
UNION ALL SELECT 'supplier_master',  count(*) FROM bronze.supplier_master
UNION ALL SELECT 'unit_cost',        count(*) FROM bronze.unit_cost
UNION ALL SELECT 'uom_conversion',   count(*) FROM bronze.uom_conversion;
