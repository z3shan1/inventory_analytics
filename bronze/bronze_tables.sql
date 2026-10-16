-- 02_bronze_tables.sql
-- Bronze layer: every source column stored as TEXT so nothing fails on load.
-- Type casting and cleaning happen in silver, where failures can be logged.
-- _source_file and _loaded_at are lineage columns and fill themselves.

DROP TABLE IF EXISTS bronze.channel_master;
CREATE TABLE bronze.channel_master (
    channel_id              TEXT,
    channel_name            TEXT,
    channel_type            TEXT,
    country                 TEXT,
    fulfilment_location_id  TEXT,
    _source_file            TEXT        DEFAULT 'channel_master.csv',
    _loaded_at              TIMESTAMPTZ DEFAULT now()
);

DROP TABLE IF EXISTS bronze.item_master;
CREATE TABLE bronze.item_master (
    sku_id            TEXT,
    brand             TEXT,
    category          TEXT,
    subcategory       TEXT,
    model_number      TEXT,
    key_spec          TEXT,
    item_type         TEXT,
    base_uom          TEXT,
    list_price_aed    TEXT,
    lifecycle_status  TEXT,
    criticality       TEXT,
    _source_file      TEXT        DEFAULT 'item_master.csv',
    _loaded_at        TIMESTAMPTZ DEFAULT now()
);

DROP TABLE IF EXISTS bronze.item_supplier;
CREATE TABLE bronze.item_supplier (
    sku_id                     TEXT,
    supplier_id                TEXT,
    is_primary                 TEXT,
    quoted_lead_time_days      TEXT,
    moq_base_units             TEXT,
    order_multiple_base_units  TEXT,
    ship_uom                   TEXT,
    _source_file               TEXT        DEFAULT 'item_supplier.csv',
    _loaded_at                 TIMESTAMPTZ DEFAULT now()
);

DROP TABLE IF EXISTS bronze.location_master;
CREATE TABLE bronze.location_master (
    location_id            TEXT,
    location_name          TEXT,
    country                TEXT,
    city                   TEXT,
    location_type          TEXT,
    transit_days_from_hub  TEXT,
    status                 TEXT,
    _source_file           TEXT        DEFAULT 'location_master.csv',
    _loaded_at             TIMESTAMPTZ DEFAULT now()
);

DROP TABLE IF EXISTS bronze.movement_history;
CREATE TABLE bronze.movement_history (
    movement_id      TEXT,
    movement_date    TEXT,
    sku_id           TEXT,
    location_id      TEXT,
    movement_type    TEXT,
    quantity         TEXT,
    uom              TEXT,
    reason_code      TEXT,
    doc_ref          TEXT,
    counterparty_id  TEXT,
    _source_file     TEXT        DEFAULT 'movement_history.csv',
    _loaded_at       TIMESTAMPTZ DEFAULT now()
);

DROP TABLE IF EXISTS bronze.open_demand;
CREATE TABLE bronze.open_demand (
    order_id                TEXT,
    order_date              TEXT,
    required_date           TEXT,
    sku_id                  TEXT,
    channel_id              TEXT,
    fulfilment_location_id  TEXT,
    open_qty                TEXT,
    uom                     TEXT,
    status                  TEXT,
    _source_file            TEXT        DEFAULT 'open_demand.csv',
    _loaded_at              TIMESTAMPTZ DEFAULT now()
);

DROP TABLE IF EXISTS bronze.open_supply;
CREATE TABLE bronze.open_supply (
    supply_ref               TEXT,
    supply_type              TEXT,
    sku_id                   TEXT,
    origin_id                TEXT,
    destination_location_id  TEXT,
    open_qty                 TEXT,
    uom                      TEXT,
    order_date               TEXT,
    promised_date            TEXT,
    status                   TEXT,
    _source_file             TEXT        DEFAULT 'open_supply.csv',
    _loaded_at               TIMESTAMPTZ DEFAULT now()
);

DROP TABLE IF EXISTS bronze.po_history;
CREATE TABLE bronze.po_history (
    po_id                    TEXT,
    sku_id                   TEXT,
    supplier_id              TEXT,
    destination_location_id  TEXT,
    order_date               TEXT,
    promised_date            TEXT,
    received_date            TEXT,
    ordered_qty              TEXT,
    received_qty             TEXT,
    order_uom                TEXT,
    _source_file             TEXT        DEFAULT 'po_history.csv',
    _loaded_at               TIMESTAMPTZ DEFAULT now()
);

DROP TABLE IF EXISTS bronze.stock_on_hand;
CREATE TABLE bronze.stock_on_hand (
    snapshot_date  TEXT,
    sku_id         TEXT,
    location_id    TEXT,
    on_hand_qty    TEXT,
    uom            TEXT,
    _source_file   TEXT        DEFAULT 'stock_on_hand.csv',
    _loaded_at     TIMESTAMPTZ DEFAULT now()
);

DROP TABLE IF EXISTS bronze.supplier_master;
CREATE TABLE bronze.supplier_master (
    supplier_id    TEXT,
    supplier_name  TEXT,
    country        TEXT,
    city           TEXT,
    currency       TEXT,
    payment_terms  TEXT,
    status         TEXT,
    _source_file   TEXT        DEFAULT 'supplier_master.csv',
    _loaded_at     TIMESTAMPTZ DEFAULT now()
);

DROP TABLE IF EXISTS bronze.unit_cost;
CREATE TABLE bronze.unit_cost (
    sku_id                       TEXT,
    effective_date               TEXT,
    unit_cost_aed_per_base_unit  TEXT,
    cost_basis                   TEXT,
    currency                     TEXT,
    _source_file                 TEXT        DEFAULT 'unit_cost.csv',
    _loaded_at                   TIMESTAMPTZ DEFAULT now()
);

DROP TABLE IF EXISTS bronze.uom_conversion;
CREATE TABLE bronze.uom_conversion (
    sku_id          TEXT,
    uom             TEXT,
    factor_to_base  TEXT,
    is_base         TEXT,
    _source_file    TEXT        DEFAULT 'uom_conversion.csv',
    _loaded_at      TIMESTAMPTZ DEFAULT now()
);

-- NOTE: _dq_answer_key.csv is intentionally NOT loaded here.
-- It goes into the audit schema only after the findings list is written.
