-- Schema and tables for market data pipeline

CREATE SCHEMA IF NOT EXISTS market;

-- Bronze layer: raw API payloads

CREATE TABLE IF NOT EXISTS market.raw_ohlcv (
    symbol TEXT NOT NULL,
    date DATE NOT NULL,
    payload JSONB NOT NULL,
    extracted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (symbol, date)
);

CREATE INDEX IF NOT EXISTS ix_raw_ohlcv_extracted_at
    ON market.raw_ohlcv (extracted_at DESC);

CREATE TABLE IF NOT EXISTS market.raw_overview (
    symbol TEXT NOT NULL,
    payload JSONB NOT NULL,
    extracted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (symbol)
);

-- Silver layer: typed data

CREATE TABLE IF NOT EXISTS market.ohlcv (
    symbol TEXT NOT NULL,
    date DATE NOT NULL,
    open NUMERIC(18,4) NOT NULL,
    high NUMERIC(18,4) NOT NULL,
    low NUMERIC(18,4) NOT NULL,
    close NUMERIC(18,4) NOT NULL,
    volume BIGINT NOT NULL,
    loaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (symbol, date)
);

CREATE INDEX IF NOT EXISTS ix_ohlcv_date ON market.ohlcv (date);

CREATE TABLE IF NOT EXISTS market.overview (
    symbol TEXT NOT NULL,
    snapshot_date DATE NOT NULL,
    asset_type TEXT,
    name TEXT,
    description TEXT,
    cik TEXT,
    exchange TEXT,
    currency TEXT,
    country TEXT,
    sector TEXT,
    industry TEXT,
    address TEXT,
    official_site TEXT,
    fiscal_year_end TEXT,
    latest_quarter DATE,
    market_capitalization NUMERIC(20,2),
    ebitda NUMERIC(20,2),
    pe_ratio NUMERIC(12,4),
    peg_ratio NUMERIC(12,4),
    book_value NUMERIC(12,4),
    dividend_per_share NUMERIC(12,4),
    dividend_yield NUMERIC(12,6),
    eps NUMERIC(12,4),
    revenue_per_share_ttm NUMERIC(12,4),
    profit_margin NUMERIC(12,6),
    operating_margin_ttm NUMERIC(12,6),
    return_on_assets_ttm NUMERIC(12,6),
    return_on_equity_ttm NUMERIC(12,6),
    revenue_ttm NUMERIC(20,2),
    gross_profit_ttm NUMERIC(20,2),
    diluted_eps_ttm NUMERIC(12,4),
    quarterly_earnings_growth_yoy NUMERIC(12,6),
    quarterly_revenue_growth_yoy NUMERIC(12,6),
    analyst_target_price NUMERIC(12,4),
    analyst_rating_strong_buy INTEGER,
    analyst_rating_buy INTEGER,
    analyst_rating_hold INTEGER,
    analyst_rating_sell INTEGER,
    analyst_rating_strong_sell INTEGER,
    trailing_pe NUMERIC(12,4),
    forward_pe NUMERIC(12,4),
    price_to_sales_ratio_ttm NUMERIC(12,4),
    price_to_book_ratio NUMERIC(12,4),
    ev_to_revenue NUMERIC(12,4),
    ev_to_ebitda NUMERIC(12,4),
    beta NUMERIC(12,4),
    week_52_high NUMERIC(12,4),
    week_52_low NUMERIC(12,4),
    moving_average_50_day NUMERIC(12,4),
    moving_average_200_day NUMERIC(12,4),
    shares_outstanding BIGINT,
    shares_float BIGINT,
    percent_insiders NUMERIC(12,6),
    percent_institutions NUMERIC(12,6),
    dividend_date DATE,
    ex_dividend_date DATE,
    loaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (symbol, snapshot_date)
);

CREATE INDEX IF NOT EXISTS ix_overview_sector ON market.overview (sector);
