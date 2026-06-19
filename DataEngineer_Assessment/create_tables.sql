CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE songs (
    song_id INT PRIMARY KEY,
    song_name VARCHAR(100),
    artist VARCHAR(100)
);

CREATE TABLE song_plays (
    play_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    song_id INT REFERENCES songs(song_id),
    played_at TIMESTAMP
);