import pandas as pd

df = pd.read_csv("songs_plays.csv")

df = df.drop_duplicates()
df = df.dropna()

df["played_at"] = pd.to_datetime(
    df["played_at"],
    errors="coerce"
)

df = df.dropna(subset=["played_at"])

df["user_id"] = df["user_id"].astype(int)
df["song_id"] = df["song_id"].astype(int)

df.to_csv("cleaned_songs_plays.csv", index=False)

print("Cleaning Completed")