# market-data-pipeline

Market data extraction and loading from Alpha Vantage API — Extract daily stock prices (OHLCV) and company fundamentals, store in PostgreSQL bronze/silver layers, and coordinate with an orchestrator notebook.

## Stack

- **Python 3.11+**
- **requests** - HTTP calls to Alpha Vantage API
- **pandas** - data transformation
- **sqlalchemy + psycopg2** - PostgreSQL connections and upsert
- **python-dotenv** - environment variable management
- **import-ipynb** - notebook imports in the orchestrator

## Project Structure

```
├── notebooks/
│   ├── api_exploration_raw.ipynb      # Initial API exploration
│   ├── 01_ohlcv.ipynb                 # Daily prices extraction (bronze/silver)
│   ├── 02_overview.ipynb              # Company fundamentals (bronze/silver)
│   ├── 03_database_connection.ipynb   # Upsert functions for both layers
│   └── 04_orchestrator.ipynb          # Coordinates daily and weekly pipelines
├── sql/ddl/
│   └── 01_create_tables.sql           # Schema and table definitions
├── .env.example
├── requirements.txt
└── README.md
```

## Quickstart

```bash
# 1. Clone
git clone https://github.com/YOUR_USERNAME/market-data-pipeline.git
cd market-data-pipeline

# 2. Set up environment
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

# 3. Configure credentials
cp .env.example .env
# Edit .env with your ALPHA_VANTAGE_API_KEY and PostgreSQL details

# 4. Create database schema
psql -U your_user -d your_db -f sql/ddl/01_create_tables.sql

# 5. Run the orchestrator notebook
jupyter notebook notebooks/04_orchestrator.ipynb
```

## Data Flow

Each notebook implements a specific layer:

- **01_ohlcv.ipynb** - `ohlcv_bronze()` calls the API, `ohlcv_silver()` transforms the payload into a typed DataFrame
- **02_overview.ipynb** - `overview_bronze()` calls the API, `overview_silver()` transforms into a single-row DataFrame
- **03_database_connection.ipynb** - Four upsert functions handle loading to `market.raw_ohlcv`, `market.raw_overview`, `market.ohlcv`, and `market.overview`
- **04_orchestrator.ipynb** - `run_ohlcv()` (daily) and `run_overview()` (weekly) coordinate the full pipeline

Data flows in memory between extraction and loading — no intermediate files. The bronze tables store raw JSON payloads for reprocessing without spending API quota.

## Data Source

[Alpha Vantage API](https://www.alphavantage.co/documentation/) - free tier (25 requests/day).

## Database Schema

Two-layer medallion architecture:

**Bronze** - raw API payloads as JSONB:
- `market.raw_ohlcv` - one row per (symbol, date)
- `market.raw_overview` - one row per symbol

**Silver** - typed, deduplicated:
- `market.ohlcv` - daily OHLCV with numeric types
- `market.overview` - company fundamentals with daily snapshots

All silver tables use `ON CONFLICT DO UPDATE` for idempotent loading.
