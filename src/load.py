
import pandas as pd
import sqlite3

CSV = 'data/processed/prices_clean.csv'
DB = 'food_prices.db'

df = pd.read_csv(CSV, parse_dates=['date'])
df['date'] = df['date'].dt.strftime('%Y-%m-%d')  # Convert to string format for 

con = sqlite3.connect(DB)
df.to_sql('prices', con, if_exists='replace', index=False)
con.execute("CREATE INDEX IF NOT EXISTS idx_prices_commodity ON prices(commodity)")
con.execute("CREATE INDEX IF NOT EXISTS idx_prices_admin2 ON prices(admin2)")
con.commit()
print("Rows in prices table:", con.execute("SELECT COUNT(*) FROM prices").fetchone()[0])
con.close()