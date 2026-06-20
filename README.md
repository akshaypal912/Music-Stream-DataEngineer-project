<div align="center">

# 🎵 Music Streaming Data Engineering Pipeline

### End-to-End Data Engineering Project using AWS EC2 · PostgreSQL · Python · SQL

![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![AWS](https://img.shields.io/badge/AWS_EC2-Ubuntu-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-Data_Cleaning-150458?style=for-the-badge&logo=pandas&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Advanced_Queries-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-Version_Control-181717?style=for-the-badge&logo=github&logoColor=white)

</div>

---

## 📌 Project Overview

This project demonstrates a **production-style Data Engineering workflow** , from raw CSV ingestion through Python-based data cleaning, cloud database loading on AWS EC2, and advanced SQL analytics on a music streaming dataset.

> **Goal:** Build a complete data pipeline for a music streaming platform , ingest raw play data, clean it programmatically with Python & Pandas, load it into a cloud-hosted PostgreSQL database, and extract meaningful insights using SQL joins, aggregations, and window functions.

---

## 🏗️ Architecture

```
                ┌─────────────────────────────┐
                │        Raw CSV Files         │
                │  users.csv        (10 users) │
                │  songs.csv       (10 songs)  │
                │  songs_plays.csv (14 records)│
                └─────────────┬───────────────┘
                              │
                              ▼
                ┌─────────────────────────────┐
                │    Python Data Cleaning      │
                │  clean_data.py               │
                │  • Remove Duplicates  (-1)   │
                │  • Drop NULL rows     (-2)   │
                │  • Fix Bad Timestamps (-1)   │
                │  • Cast float IDs → int      │
                └─────────────┬───────────────┘
                              │
                              ▼
                  cleaned_songs_plays.csv
                       (10 clean rows)
                              │
                              ▼
                ┌─────────────────────────────┐
                │       AWS EC2 Ubuntu         │
                │     PostgreSQL Database      │
                │                             │
                │  ┌──────────┐  ┌─────────┐  │
                │  │  users   │  │  songs  │  │
                │  └────┬─────┘  └────┬────┘  │
                │       └──────┬───────┘       │
                │         ┌────▼──────┐        │
                │         │ song_plays│        │
                │         └───────────┘        │
                └─────────────┬───────────────┘
                              │
                              ▼
                ┌─────────────────────────────┐
                │         SQL Analysis         │
                │  • Plays per song            │
                │  • Most active users         │
                │  • Listening history         │
                │  • ROW_NUMBER() window fn    │
                │  • Top played song           │
                └─────────────┬───────────────┘
                              │
                              ▼
                   📊 Query Results & Insights
```

---

## 🛠️ Technologies Used

| Layer | Technology | Purpose |
|---|---|---|
| **Cloud** | AWS EC2 (Ubuntu) | Remote server to host the database |
| **Database** | PostgreSQL 15 | Relational storage, FK constraints, indexes |
| **Language** | Python 3.10+ | Data cleaning automation |
| **Library** | Pandas | DataFrame operations & CSV handling |
| **Query Language** | SQL | JOINs, aggregations, window functions |
| **Version Control** | Git & GitHub | Project tracking & collaboration |

---

## 📁 Project Structure

```
DataEngineer_Assessment/
│
├── 📄 users.csv                  ← 10 users (user_id, user_name, email)
├── 📄 songs.csv                  ← 10 songs (song_id, song_name, artist)
├── 📄 songs_plays.csv            ← 14 raw play events (with noise)
├── 📄 cleaned_songs_plays.csv    ← 10 clean records (pipeline output)
│
├── 🗄️  create_tables.sql          ← DDL: schema + FK constraints + indexes
├── 🔍 sql_queries.sql             ← 5 core + 2 bonus analysis queries
├── 🐍 clean_data.py               ← Python cleaning pipeline (4 steps)
│
├── 📸 screenshots/                ← Query result screenshots from EC2
└── 📖 README.md
```

---

## 🗄️ Database Schema

### `users`
| Column | Type | Constraint |
|---|---|---|
| user_id | INT | PRIMARY KEY |
| user_name | VARCHAR(100) | NOT NULL |
| email | VARCHAR(150) | UNIQUE, NOT NULL |

**Sample data:**
| user_id | user_name | email |
|---|---|---|
| 1 | Akshay | akshay@gmail.com |
| 2 | Rahul | rahul@gmail.com |
| 3 | Aman | aman@gmail.com |
| … | … | … |

---

### `songs`
| Column | Type | Constraint |
|---|---|---|
| song_id | INT | PRIMARY KEY |
| song_name | VARCHAR(200) | NOT NULL |
| artist | VARCHAR(150) | NOT NULL |

**Sample data:**
| song_id | song_name | artist |
|---|---|---|
| 101 | Believer | Imagine Dragons |
| 102 | Perfect | Ed Sheeran |
| 105 | Faded | Alan Walker |
| … | … | … |

---

### `song_plays` *(fact table)*
| Column | Type | Constraint |
|---|---|---|
| play_id | SERIAL | PRIMARY KEY |
| user_id | INT | FK → users(user_id) |
| song_id | INT | FK → songs(song_id) |
| played_at | TIMESTAMP | NOT NULL |

> Performance indexes on `user_id`, `song_id`, and `played_at`.

---

## 🐍 Data Cleaning Pipeline (`clean_data.py`)

The script processes `songs_plays.csv` through **4 structured steps**:

```
Raw Data: 14 rows
     │
     ▼  [1/4] Remove Duplicates       → -1 row  (exact duplicate found)
     │
     ▼  [2/4] Drop NULL rows          → -2 rows (missing user_id / song_id)
     │
     ▼  [3/4] Standardise Timestamps  → -1 row  (bad format: 20-06-2026)
     │
     ▼  [4/4] Cast float IDs → int    (Pandas artifact after dropna)
     │
Clean Output: 10 rows → cleaned_songs_plays.csv
```

**Run it:**
```bash
python3 clean_data.py
```

**Actual output:**
```
====================================================
  Loaded  : songs_plays.csv
  Rows    : 14
  Columns : ['user_id', 'song_id', 'played_at']
====================================================

── Data Quality Report (raw) ─────────────────────
  Total rows        : 14
  Duplicate rows    : 1
  Rows with nulls   : 2
  Null counts per column:
    user_id        : 1
    song_id        : 1
    played_at      : 0

── Cleaning Steps ────────────────────────────────
[1/4] Removed duplicates    : 1 row(s)  →  13 remaining
[2/4] Removed null rows     : 2 row(s)  →  11 remaining
         ⚠  1 unparseable timestamp(s) will be dropped
[3/4] Timestamps normalised : format → '%Y-%m-%d %H:%M:%S'
[4/4] ID columns cast       : float → int

── Final Stats ───────────────────────────────────
  Clean rows : 10

✅  Cleaned data saved → 'cleaned_songs_plays.csv'  (10 rows)
```

---

## 🔍 SQL Analysis Queries

### Query 1 — Total Plays Per Song
```sql
SELECT s.song_name, s.artist, COUNT(sp.play_id) AS total_plays
FROM songs s
LEFT JOIN song_plays sp ON s.song_id = sp.song_id
GROUP BY s.song_id, s.song_name, s.artist
ORDER BY total_plays DESC;
```

### Query 2 — Most Active Users
```sql
SELECT u.user_name, u.email, COUNT(sp.play_id) AS total_plays
FROM users u
LEFT JOIN song_plays sp ON u.user_id = sp.user_id
GROUP BY u.user_id, u.user_name, u.email
ORDER BY total_plays DESC;
```

### Query 3 — User Listening History
```sql
SELECT u.user_name, s.song_name, s.artist, sp.played_at
FROM song_plays sp
JOIN users  u ON sp.user_id = u.user_id
JOIN songs  s ON sp.song_id = s.song_id
ORDER BY sp.played_at DESC;
```

### Query 4 — Window Function: ROW_NUMBER per User
```sql
SELECT
    u.user_name, s.song_name, sp.played_at,
    ROW_NUMBER() OVER (
        PARTITION BY sp.user_id
        ORDER BY sp.played_at DESC
    ) AS play_rank
FROM song_plays sp
JOIN users u ON sp.user_id = u.user_id
JOIN songs s ON sp.song_id = s.song_id;
```

### Query 5 — Top Played Song
```sql
SELECT s.song_name, s.artist, COUNT(sp.play_id) AS total_plays
FROM songs s
JOIN song_plays sp ON s.song_id = sp.song_id
GROUP BY s.song_name, s.artist
ORDER BY total_plays DESC
LIMIT 1;
```

---

## 🚀 How To Run

### 1. Connect to EC2
```bash
ssh -i <your-key.pem> ubuntu@<your-ec2-public-ip>
```

### 2. Install Dependencies
```bash
sudo apt update && sudo apt install postgresql python3-pip -y
pip3 install pandas
```

### 3. Create the Database
```bash
sudo -u postgres psql
```
```sql
CREATE DATABASE music_db;
\c music_db
```

### 4. Create Tables
```bash
psql -U postgres -d music_db -f create_tables.sql
```

### 5. Run the Cleaning Script
```bash
python3 clean_data.py
```

### 6. Load Data into PostgreSQL
```bash
psql -U postgres -d music_db -c "\COPY users      FROM 'users.csv'               CSV HEADER;"
psql -U postgres -d music_db -c "\COPY songs      FROM 'songs.csv'               CSV HEADER;"
psql -U postgres -d music_db -c "\COPY song_plays FROM 'cleaned_songs_plays.csv' CSV HEADER;"
```

### 7. Verify Row Counts
```sql
SELECT COUNT(*) FROM users;       -- Expected: 10
SELECT COUNT(*) FROM songs;       -- Expected: 10
SELECT COUNT(*) FROM song_plays;  -- Expected: 9
```

### 8. Run SQL Queries
```bash
psql -U postgres -d music_db -f sql_queries.sql
```

---

## 📊 Results Summary

| Metric | Value |
|---|---|
| Raw play records loaded | 14 |
| Duplicates removed | 1 |
| NULL rows dropped | 2 |
| Bad timestamps dropped | 1 |
| **Clean records loaded to DB** | **10** |
| SQL queries written | 7 (5 core + 2 bonus) |
| Database tables | 3 |
| Indexes created | 3 |

---

## 💡 Skills Demonstrated

- ☁️ **Cloud** — AWS EC2 instance setup and SSH access
- 🗄️ **Database Design** — normalized schema with foreign keys and indexes , windows powershell
- 🐍 **Python / Pandas** — automated 4-step cleaning pipeline with detailed logging
- 🔍 **SQL** — JOINs, GROUP BY, aggregations, window functions 
- 📁 **Engineering Practices** — modular code, comments, Git version control

---

## 👤 Author

**Akshay Pal**  
B.Tech — Data Science
---

<div align="center">

*Built with ❤️ as part of a Data Engineering Assessment*

</div>
