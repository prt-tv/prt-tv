-- SQL Project:- Data Cleaning

-- Skill Use:- CTEs, Window Function, String Function

SELECT *
FROM `most streamed spotify songs 2024`;

CREATE TABLE spotify_staging
LIKE `most streamed spotify songs 2024`;

INSERT INTO spotify_staging
SELECT *
FROM `most streamed spotify songs 2024`;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY Track, `Album Name`, Artist, `Release Date`, ISRC, `All Time Rank`, `Track Score`, `Spotify Streams`,
`Spotify Playlist Count`, `Spotify Playlist Reach`,`Spotify Popularity`, `YouTube Likes`, `YouTube Views`, `YouTube Playlist Reach`,
`TikTok Likes`, `TikTok Posts`, `TikTok Views`,  `Apple Music Playlist Count`, `AirPlay Spins`, `SiriusXM Spins`, `Deezer Playlist Count`,
`Deezer Playlist Reach`, `Amazon Playlist Count`, `Pandora Streams`, `Pandora Track Stations`, `Soundcloud Streams`, `Shazam Counts`, `TIDAL Popularity`, `Explicit Track`)
FROM spotify_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Track, `Album Name`, Artist, `Release Date`, ISRC, `All Time Rank`, `Track Score`, `Spotify Streams`,
`Spotify Playlist Count`, `Spotify Playlist Reach`,`Spotify Popularity`, `YouTube Likes`, `YouTube Views`, `YouTube Playlist Reach`,
`TikTok Likes`, `TikTok Posts`, `TikTok Views`,  `Apple Music Playlist Count`, `AirPlay Spins`, `SiriusXM Spins`, `Deezer Playlist Count`,
`Deezer Playlist Reach`, `Amazon Playlist Count`, `Pandora Streams`, `Pandora Track Stations`, `Soundcloud Streams`, `Shazam Counts`, `TIDAL Popularity`, `Explicit Track`)
AS row_num
FROM spotify_staging 
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT  Track 
FROM spotify_staging
WHERE Track LIKE 'wo%';

SELECT track, TRIM(TRAILING '.' FROM track)
FROM spotify_staging
WHERE Track LIKE 'wo%';

UPDATE spotify_staging
SET track = TRIM(TRAILING '.' FROM track)
WHERE track LIKE 'wo%';

SELECT `Release Date` , STR_TO_DATE(`release date` , '%m/%d/%Y')
FROM spotify_staging;
 
UPDATE spotify_staging
SET `release date` =  STR_TO_DATE(`release date`, '%m/%d/%Y');

ALTER TABLE spotify_staging
MODIFY `Release Date` DATE;
