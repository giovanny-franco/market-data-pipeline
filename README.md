# market-data-pipeline

Market data extraction from Alpha Vantage API — Extract daily stock prices (OHLCV) and explore data transformations with pandas.

## Stack

- **Python 3.11+**
- **requests** — HTTP calls to Alpha Vantage API
- **pandas** — data transformation and exploration
- **python-dotenv** — environment variable management

## Project Structure

```
├── notebooks/          # Exploration and prototyping
│   └── 01_api_exploration.ipynb
└── README.md
```

## Quickstart

```bash
# 1. Clone
git clone https://github.com/YOUR_USERNAME/market-data-pipeline.git
cd market-data-pipeline

# 2. Set up the environment
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

# 3. Configure environment variables
cp .env.example .env
# edit .env with your ALPHA_VANTAGE_API_KEY

# 4. Run the notebook
jupyter notebook notebooks/01_api_exploration.ipynb
```

## Data Source

[Alpha Vantage API](https://www.alphavantage.co/documentation/) — free tier (25 requests/day).

## What's Inside

`01_api_exploration.ipynb` demonstrates:
- Fetching daily stock prices (OHLCV) from Alpha Vantage
- Transforming raw API responses into clean pandas DataFrames
- Extracting data for multiple tickers while respecting rate limits
