-- 01_schemas.sql
-- Medallion layers + audit schema for the inventory_analytics database.
-- Run while connected to: inventory_analytics

CREATE SCHEMA IF NOT EXISTS bronze;  -- raw, untouched copies of the source CSVs
CREATE SCHEMA IF NOT EXISTS silver;  -- cleaned, typed, deduplicated
CREATE SCHEMA IF NOT EXISTS gold;    -- business-ready facts and dimensions
CREATE SCHEMA IF NOT EXISTS audit;   -- data quality log (and answer key, loaded last)

CREATE TABLE IF NOT EXISTS audit.dq_issues (
    issue_id      SERIAL PRIMARY KEY,
    table_name    TEXT,
    record_key    TEXT,
    rule          TEXT,
    severity      TEXT,
    action_taken  TEXT,
    found_at      TIMESTAMPTZ DEFAULT now()
);




