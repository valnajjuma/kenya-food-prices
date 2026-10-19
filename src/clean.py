import pandas as pd

RAW = "data/raw/wfp_food_prices_ken.csv"
OUT = "data/processed/prices_clean.csv"

df = pd.read_csv(RAW)

df['date'] = pd.to_datetime(df['date'], errors = 'coerce')
df['price'] = pd.to_numeric(df['price'], errors = 'coerce')
df=df.dropna(subset=['date','price'])
df=df[df['price']>0]
df=df.drop_duplicates()

for col in ['commodity','market','admin1','admin2','category']:
    df[col] = df[col].str.strip()

df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month

#Standardize units to price per kg/per liter
def parse_unit(u):
    u = str(u).upper().strip()
    factors = {
        "KG" : (1,'kg'), "90 KG": (90, "kg"), "50 KG": (50, "kg"),
        "64 KG": (64, "kg"), "126 KG": (126, "kg"), "13 KG": (13, "kg"),
        "400 G": (0.4, "kg"),'200 G': (0.2, "kg"), "L": (1,"L"),
        "500 ML": (0.5, "L"),
    }
    return factors.get(u, (None, None))

df[['unit_qty', 'unit_type']] = df['unit'].apply(lambda u: pd.Series(parse_unit(u)))
df['price_per_std'] = df['price'] / df['unit_qty']
df['usdprice_per_std'] = df['usdprice'] / df['unit_qty']

df.to_csv(OUT, index=False)
print(f'Saved {len(df)} rows to {OUT}')
print('Rows with unconverted unit:', df['unit_qty'].isna().sum())