use ig_clone;

-- Identify the five oldest users on Instagram
SELECT 
    username, 
    created_at
FROM 
    users
ORDER BY 
    created_at 
LIMIT 5;

-- Identify users who have never posted 
-- a single photo on Instagram
SELECT
	u.id, u.username 
FROM
    users u
LEFT JOIN 
    photos p
ON 
    u.id = p.user_id
WHERE 
    p.user_id IS NULL;
    
    
-- Identify winner of contest
SELECT 
    p.user_id, 
    u.username, 
    p.image_url, 
    COUNT(l.user_id) AS total_likes
FROM 
    photos p
INNER JOIN 
    likes l ON l.photo_id = p.id
INNER JOIN 
    users u ON p.user_id = u.id
GROUP BY 
    p.id
ORDER BY 
    total_likes DESC
LIMIT 1;

-- Top Hashtag 
SELECT
    t.tag_name,
    COUNT(p.photo_id) AS num_tag
FROM 
    photo_tags p
INNER JOIN 
	tags t ON p.tag_id = t.id
GROUP BY
    tag_name
ORDER BY
    num_tag DESC
LIMIT 5;

-- Determine the day of the week 
-- when most users register on Instagram.
SELECT 
    DAYNAME(created_at) AS day_of_week,
    COUNT(id) AS num_registration
FROM
    users
GROUP BY
    day_of_week
ORDER BY 
    num_registration DESC;

-- user engagement
SELECT
    total_posts,
    total_users,
    total_posts / total_users AS avg_posts
FROM (
    SELECT
        (SELECT COUNT(id) FROM photos) AS total_posts,
        (SELECT COUNT(id) FROM users) AS total_users
) AS temp;

-- avg based on user who post atleast 1 photo
SELECT
    COUNT(id) AS total_posts,
    COUNT(distinct user_id) AS active_users,
    COUNT(id)/COUNT(distinct user_id) AS avg_posts
FROM photos;


-- Identify Bots & Fake Accounts
SELECT 
    u.id, 
    u.username, 
    COUNT(l.photo_id) AS total_likes
FROM 
    users u
JOIN 
    likes l ON u.id = l.user_id
GROUP BY 
    u.id
HAVING 
    total_likes = (SELECT COUNT(id) FROM photos);
