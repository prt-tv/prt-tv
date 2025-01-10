SKILL USE :- Aggregate Functions, CTEs, Window Functions, SubQueries, Filter Functions, Sort Functions

SELECT *
FROM spotify_staging;

SELECT `Album Name`, Artist, `Spotify Streams`, `Spotify Popularity`, `YouTube Views`
FROM spotify_staging;

SELECT `Artist`, MAX(`Spotify Streams`), MAX(`YouTube Views`)
FROM spotify_staging
GROUP BY `Artist`;

SELECT MAX(`Release Date`) , MIN(`Release Date`)
FROM spotify_staging;

SELECT DISTINCT `Album Name`,  COUNT(`Spotify Streams`), COUNT(`YouTube Views`)
FROM spotify_staging
GROUP BY `Album Name`
ORDER BY 2 DESC;

WITH spotify_reach (artist, MONTH, `spotify_stream`) AS
(
SELECT `Artist`, MONTH(`Release Date`), MAX(`Spotify Streams`)
FROM spotify_staging
WHERE `Release Date` LIKE '2020_____%'
GROUP BY `Artist`, MONTH(`Release Date`)
), 
spotify_month_rank AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY MONTH ORDER BY `spotify_stream` DESC) AS ranking
FROM spotify_reach
)
SELECT *
FROM spotify_month_rank
WHERE ranking <= 10
;

SELECT Artist, `Spotify Streams`, `Spotify Popularity`,`Spotify Playlist Reach`, `YouTube Views`, `YouTube Playlist Reach`, `Release Date`, `Album Name`,
(`Spotify Streams`) / ( `YouTube Views`) AS Popularity
FROM spotify_staging;

SELECT *
FROM spotify_staging
WHERE `Release Date` LIKE '2020_____%' ;

WITH popularity_artist (`Album Name`, `Artist`,YEAR, `Spotify Popularity`,`Spotify Streams`,`YouTube Views`) AS
(
SELECT `Album Name`, `Artist`, YEAR(`Release Date`), `Spotify Popularity` , MAX(`Spotify Streams`) AS max_stream, MAX(`YouTube Views`) AS max_views
FROM spotify_staging
WHERE `Release Date` LIKE '2020_____%'  
GROUP BY  `Album Name`, `Artist`, YEAR(`Release Date`), `Spotify Popularity`
),
popularity_artist_rank AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY YEAR ORDER BY `youtube views` DESC) AS ranking
FROM popularity_artist
)
SELECT *
FROM popularity_artist_rank
WHERE ranking <= 5;

WITH Most_view_artist  AS 
(
SELECT Artist, `Album Name`, MONTH(`Release Date`) , MAX(`YouTube Views`) as max_view
FROM spotify_staging
WHERE `Release Date` LIKE '2020______%'
GROUP BY Artist, `Album Name`, MONTH(`Release Date`) 
ORDER BY 4 DESC
)
SELECT *
FROM Most_view_artist
WHERE max_view <=5;
  
SELECT Artist,`Album Name`,YEAR(`Release Date`), SUM(`Spotify Popularity`)
FROM spotify_staging
GROUP BY Artist,`Album Name`,YEAR(`Release Date`)
ORDER BY 3 DESC;

SELECT `Album Name`,`Spotify Streams`, `YouTube Views`,(`Spotify Streams` / `YouTube Views`)
FROM spotify_staging
WHERE `artist`= 'BTS' ;


SELECT artist, `Album Name`, `Shazam Counts`,
(SELECT AVG(`Shazam Counts`)
FROM spotify_staging)
FROM spotify_staging
;

SELECT `Album Name`, `All Time Rank`, AVG(`Spotify Streams`), MAX(`Spotify Streams`), MIN(`Spotify Streams`), COUNT(`Spotify Streams`)
FROM spotify_staging
GROUP BY `Album Name`, `All Time Rank`;

SELECT *
FROM 
(SELECT `Album Name`, `All Time Rank`, AVG(`Spotify Streams`), MAX(`Spotify Streams`), MIN(`Spotify Streams`), COUNT(`Spotify Streams`)
FROM spotify_staging
GROUP BY `Album Name`, `All Time Rank`) AS stream_table;
