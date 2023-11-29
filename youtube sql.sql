
-- Switch to the 'youtube' database
USE youtube;

-- Create a table for YouTube video data
CREATE TABLE `youtube`.`yt_video` (
    -- Columns with information about the video
    `title` VARCHAR(255) DEFAULT NULL,
    `channel_name` VARCHAR(255) DEFAULT NULL,
    `daily_rank` INT DEFAULT NULL,
    `daily_movement` INT DEFAULT NULL,
    `weekly_movement` INT DEFAULT NULL,
    `snapshot_date` DATE DEFAULT NULL,
    `country` VARCHAR(50) DEFAULT NULL,
    `view_count` INT DEFAULT NULL,
    `like_count` INT DEFAULT NULL,
    `comment_count` INT DEFAULT NULL,
    `thumbnail_url` VARCHAR(255) DEFAULT NULL,
    `video_id` VARCHAR(255) DEFAULT NULL,
    `channel_id` VARCHAR(255) DEFAULT NULL,
    `video_tags` TEXT DEFAULT NULL,
    `kind` VARCHAR(255) DEFAULT NULL, 
    `publish_date` DATETIME DEFAULT NULL,
    `language` VARCHAR(255) DEFAULT NULL 
);

-- Load data from a CSV file into the 'yt_video' table
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\trending_yt_videos_113_countries.csv'
INTO TABLE `youtube`.`yt_video`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS  -- Skip header if present
(
    -- Map columns in CSV file to columns in the 'yt_video' table
    title, channel_name, daily_rank, daily_movement, weekly_movement, 
    @snapshot_date, country, view_count, like_count, comment_count, 
    thumbnail_url, video_id, channel_id, video_tags, kind, @publish_date, language
)
SET
    -- Convert 'snapshot_date' from string to DATE format
    snapshot_date = STR_TO_DATE(@snapshot_date, '%d/%m/%Y'),
    -- Convert 'publish_date' from string to DATETIME format
    publish_date = STR_TO_DATE(@publish_date, '%Y-%m-%d %H:%i:%s+00:00');

-- Overall Statistics:

-- 1.	What is the total number of videos in the dataset?
SELECT
    'title' AS column_name,
    COUNT(DISTINCT title) AS distinct_count_title,
    'channel_name' AS column_name,
    COUNT(DISTINCT channel_name) AS distinct_count_channel_name,
    'daily_rank' AS column_name,
    COUNT(DISTINCT daily_rank) AS distinct_count_daily_rank,
    'daily_movement' AS column_name,
    COUNT(DISTINCT daily_movement) AS distinct_count_daily_movement,
    'weekly_movement' AS column_name,
    COUNT(DISTINCT weekly_movement) AS distinct_count_weekly_movement,
    'snapshot_date' AS column_name,
    COUNT(DISTINCT snapshot_date) AS distinct_count_snapshot_date,
    'country' AS column_name,
    COUNT(DISTINCT country) AS distinct_count_country,
    'view_count' AS column_name,
    COUNT(DISTINCT view_count) AS distinct_count_view_count,
    'like_count' AS column_name,
    COUNT(DISTINCT like_count) AS distinct_count_like_count,
    'comment_count' AS column_name,
    COUNT(DISTINCT comment_count) AS distinct_count_comment_count,
    'thumbnail_url' AS column_name,
    COUNT(DISTINCT thumbnail_url) AS distinct_count_thumbnail_url,
    'video_id' AS column_name,
    COUNT(DISTINCT video_id) AS distinct_count_video_id,
    'channel_id' AS column_name,
    COUNT(DISTINCT channel_id) AS distinct_count_channel_id,
    'video_tags' AS column_name,
    COUNT(DISTINCT video_tags) AS distinct_count_video_tags,
    'kind' AS column_name,
    COUNT(DISTINCT kind) AS distinct_count_kind,
    'publish_date' AS column_name,
    COUNT(DISTINCT publish_date) AS distinct_count_publish_date,
    'language' AS column_name,
    COUNT(DISTINCT language) AS distinct_count_language
FROM youtube.yt_video;


-- ANSWER: THERE ARE 17889 UNIQUE VIDEOS 

SELECT COUNT(*) AS total_rows
FROM youtube.yt_video;

-- 2.	What is the total number of channels?
-- ANSWER: THERE ARE 9955 UNIQUE CHANELS

-- Channel Insights:
-- 1. Which 10 channels have the highest average view count?
SELECT
    channel_name,
    AVG(view_count) AS average_view_count
FROM youtube.yt_video
GROUP BY channel_name
ORDER BY average_view_count DESC
LIMIT 10;

-- 2. Which 10 channels have the highest average like count?
SELECT
    channel_name,
    AVG(like_count) AS average_like_count
FROM youtube.yt_video
GROUP BY channel_name
ORDER BY average_like_count DESC
LIMIT 10;

-- 3. Which 10 channels have the highest average comment count?
SELECT
    channel_name,
    AVG(comment_count) AS average_comment_count
FROM youtube.yt_video
GROUP BY channel_name
ORDER BY average_comment_count DESC
LIMIT 10;


-- Video Metrics:
-- 1.	What is the average view count for all videos?
SELECT AVG(view_count) AS average_view_count
FROM youtube.yt_video;

-- 2. What is the average like count for all videos?
SELECT AVG(like_count) AS average_like_count
FROM youtube.yt_video;

-- 3. What is the average comment count for all videos?
SELECT AVG(comment_count) AS average_comment_count
FROM youtube.yt_video;

-- Popular Videos:

-- 1. Which videos have the highest view count?
SELECT
    title,
    view_count
FROM youtube.yt_video
ORDER BY view_count DESC
LIMIT 10;

-- 2. Which videos have the highest like count?
SELECT
    title,
    like_count
FROM youtube.yt_video
ORDER BY like_count DESC
LIMIT 10;

-- 3. Which videos have the highest comment count?
SELECT
    title,
    comment_count
FROM youtube.yt_video
ORDER BY comment_count DESC
LIMIT 10;

-- Daily Movement Analysis:

-- 1. How many videos have positive daily movement?
SELECT COUNT(*) AS videos_with_positive_daily_movement
FROM youtube.yt_video
WHERE daily_movement > 0;

-- 2. How many videos have negative daily movement?
SELECT COUNT(*) AS videos_with_negative_daily_movement
FROM youtube.yt_video
WHERE daily_movement < 0;

-- Weekly Movement Analysis:

-- 1. How many videos have positive weekly movement?
SELECT COUNT(*) AS videos_with_positive_weekly_movement
FROM youtube.yt_video
WHERE weekly_movement > 0;

-- 2. How many videos have negative weekly movement?
SELECT COUNT(*) AS videos_with_negative_weekly_movement
FROM youtube.yt_video
WHERE weekly_movement < 0;

-- Temporal Trends:

-- 1. What is the trend of view count in last 2 weeks?
SELECT
    snapshot_date,
    AVG(view_count) AS average_view_count
FROM youtube.yt_video
GROUP BY snapshot_date
ORDER BY snapshot_date
LIMIT 14;

-- 2. What is the trend of like count in last 2 weeks?
SELECT
    snapshot_date,
    AVG(like_count) AS average_like_count
FROM youtube.yt_video
GROUP BY snapshot_date
ORDER BY snapshot_date
LIMIT 14;

-- 3. What is the trend of comment count in last 2 weeks?
SELECT
    snapshot_date,
    AVG(comment_count) AS average_comment_count
FROM youtube.yt_video
GROUP BY snapshot_date
ORDER BY snapshot_date
LIMIT 14;

-- Country-wise Analysis:

-- 1. Which Top 10 countries have the highest average view count?
SELECT
    country,
    AVG(view_count) AS average_view_count
FROM youtube.yt_video
GROUP BY country
ORDER BY average_view_count DESC
LIMIT 10;

-- 2. Which top 10 countries have the highest average like count?
SELECT
    country,
    AVG(like_count) AS average_like_count
FROM youtube.yt_video
GROUP BY country
ORDER BY average_like_count DESC
LIMIT 10;

-- 3. Which top 10 countries have the highest average comment count?
SELECT
    country,
    AVG(comment_count) AS average_comment_count
FROM youtube.yt_video
GROUP BY country
ORDER BY average_comment_count DESC
LIMIT 10;

-- Correlation Analysis:

-- 1. Is there a correlation between daily rank and view count?
SELECT
    (
        COUNT(*) * SUM(daily_rank * view_count) - SUM(daily_rank) * SUM(view_count)
    ) / (
        SQRT((COUNT(*) * SUM(daily_rank * daily_rank) - POW(SUM(daily_rank), 2)) * (COUNT(*) * SUM(view_count * view_count) - POW(SUM(view_count), 2)))
    ) AS correlation_daily_rank_view_count
FROM youtube.yt_video;


-- Top Performers:

-- 1. Which top 10 channels have the highest total view count?
SELECT
    channel_name,
    SUM(view_count) AS total_view_count
FROM youtube.yt_video
GROUP BY channel_name
ORDER BY total_view_count DESC
LIMIT 10;

-- 2. Which top 10 channels have the highest total like count?
SELECT
    channel_name,
    SUM(like_count) AS total_like_count
FROM youtube.yt_video
GROUP BY channel_name
ORDER BY total_like_count DESC
LIMIT 10;

-- 3. Which top 10 channels have the highest total comment count?
SELECT
    channel_name,
    SUM(comment_count) AS total_comment_count
FROM youtube.yt_video
GROUP BY channel_name
ORDER BY total_comment_count DESC
LIMIT 10;



-- 4. Analyze daily video movements to uncover sudden spikes or drops in popularity.
SELECT
    video_id,
    daily_movement
FROM youtube.yt_video
ORDER BY daily_movement DESC
LIMIT 10;

-- 5. Discover which 10 countries have the most consistent or volatile trending videos.
SELECT
    country,
    AVG(daily_movement) AS average_daily_movement
FROM youtube.yt_video
GROUP BY country
ORDER BY average_daily_movement ASC
LIMIT 10;

-- 6. Track the performance of specific YouTube channels across different countries.
SELECT
    channel_name,
    country,
    AVG(view_count) AS average_view_count
FROM youtube.yt_video
GROUP BY channel_name, country
ORDER BY average_view_count DESC
LIMIT 10;




-- 7. Visualize the distribution of video languages across different countries.
SELECT
    country,
    language,
    COUNT(*) AS video_count
FROM youtube.yt_video
GROUP BY country, language
ORDER BY video_count DESC
limit 20;

-- WEEKLY analysis

SELECT
    MIN(snapshot_date) AS oldest_date,
    MAX(snapshot_date) AS newest_date
FROM youtube.yt_video;

SELECT
    YEARWEEK(snapshot_date) AS year_week,
    COUNT(*) AS video_count,
    AVG(view_count) AS average_view_count,
    AVG(like_count) AS average_like_count,
    AVG(comment_count) AS average_comment_count
FROM youtube.yt_video
GROUP BY YEARWEEK(snapshot_date)
ORDER BY year_week DESC;



-- Find the day with the highest number of videos posted and the video with the highest view count on that day:
SELECT
    posting_day,
    videos_posted,
    video_with_highest_views,
    highest_view_count
FROM (
    SELECT
        snapshot_date AS posting_day,
        COUNT(*) AS videos_posted,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS videos_posted_rank,
        video_id AS video_with_highest_views,
        MAX(view_count) AS highest_view_count,
        RANK() OVER (ORDER BY MAX(view_count) DESC) AS highest_view_rank
    FROM youtube.yt_video
    GROUP BY snapshot_date
) AS ranked_data
WHERE videos_posted_rank = 1 OR highest_view_rank = 1
ORDER BY posting_day;
;

-- Calculate the average of data split by weekdays (Monday, Tuesday, etc.):
SELECT
    yt.channel_name,
    DAYNAME(yt.snapshot_date) AS upload_weekday,
    COUNT(*) AS number_of_videos,
    SUM(yt.view_count) AS total_views,
    SUM(yt.like_count) AS total_likes,
    SUM(yt.comment_count) AS total_comments,
    MAX(yt.country) AS country
FROM youtube.yt_video yt
JOIN (
    SELECT
        channel_name
    FROM youtube.yt_video
    GROUP BY channel_name
    ORDER BY SUM(view_count) DESC
    LIMIT 5
) top_channels
ON yt.channel_name = top_channels.channel_name
GROUP BY yt.channel_name, upload_weekday
ORDER BY yt.channel_name, total_views DESC;


    
    




