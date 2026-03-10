CREATE SCHEMA IF NOT EXISTS dw;

CREATE TABLE dw.dim_date (
    date_key SERIAL PRIMARY KEY,
    full_date DATE UNIQUE,
    year INT,
    month INT,
    day INT,
    quarter INT
);

CREATE TABLE dw.dim_customer (
    customer_key SERIAL PRIMARY KEY,
    source_id INT UNIQUE,
    full_name TEXT,
    region_code TEXT
);

CREATE TABLE dw.dim_product (
    product_key SERIAL PRIMARY KEY,
    source_id INT UNIQUE,
    product_name TEXT,
    category TEXT,
    unit_price NUMERIC
);

CREATE TABLE dw.dim_branch (
    branch_key SERIAL PRIMARY KEY,
    source_id INT UNIQUE,
    branch_name TEXT,
    city TEXT,
    region TEXT
);

CREATE TABLE dw.fact_sales (
    sales_key SERIAL PRIMARY KEY,
    source_txn_id INT UNIQUE,
    date_key INT,
    customer_key INT,
    product_key INT,
    branch_key INT,
    qty INT,
    unit_price NUMERIC,
    total_amount NUMERIC,

    FOREIGN KEY (date_key) REFERENCES dw.dim_date(date_key),
    FOREIGN KEY (customer_key) REFERENCES dw.dim_customer(customer_key),
    FOREIGN KEY (product_key) REFERENCES dw.dim_product(product_key),
    FOREIGN KEY (branch_key) REFERENCES dw.dim_branch(branch_key)
);

CREATE TABLE dw.etl_log (
    run_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status TEXT,
    rows_loaded INT,
    error_message TEXT
);

CREATE INDEX idx_fact_date ON dw.fact_sales(date_key);
CREATE INDEX idx_fact_branch ON dw.fact_sales(branch_key);
CREATE INDEX idx_fact_product ON dw.fact_sales(product_key);
