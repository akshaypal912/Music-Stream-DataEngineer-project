--Total plays per song
SELECT
    s.song_name,
    COUNT(*) AS total_plays
FROM song_plays sp
JOIN songs s
ON sp.song_id = s.song_id
GROUP BY s.song_name
ORDER BY total_plays DESC;

--Most active users
SELECT
    u.user_name,
    COUNT(*) AS total_plays
FROM song_plays sp
JOIN users u
ON sp.user_id = u.user_id
GROUP BY u.user_name
ORDER BY total_plays DESC;

--User and Song History
SELECT
    u.user_name,
    s.song_name,
    sp.played_at
FROM song_plays sp
JOIN users u
ON sp.user_id = u.user_id
JOIN songs s
ON sp.song_id = s.song_id
ORDER BY played_at;

--Window Function
SELECT
    user_id,
    song_id,
    played_at,
    ROW_NUMBER() OVER(
        PARTITION BY user_id
        ORDER BY played_at
    ) AS play_number
FROM song_plays;

--Top Played Song
SELECT
    s.song_name,
    COUNT(*) AS plays
FROM song_plays sp
JOIN songs s
ON sp.song_id = s.song_id
GROUP BY s.song_name
ORDER BY plays DESC
LIMIT 1;