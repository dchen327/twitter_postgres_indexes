/*
 * Calculates the hashtags that are commonly used with the hashtag #coronavirus
 */
WITH hits AS (
  SELECT data->>'id' AS id_tweets
  FROM tweets_jsonb
  WHERE (
    COALESCE(data->'entities'->'hashtags','[]')
    || COALESCE(data->'extended_tweet'->'entities'->'hashtags','[]')
  ) @> '[{"text":"coronavirus"}]'
)
SELECT
  h->>'text' AS tag,
  COUNT(*)      AS count
FROM hits
JOIN tweets_jsonb t
  ON t.data->>'id' = hits.id_tweets
CROSS JOIN LATERAL
  jsonb_array_elements(
    COALESCE(t.data->'entities'->'hashtags','[]')
    || COALESCE(t.data->'extended_tweet'->'entities'->'hashtags','[]')
  ) AS h
WHERE h->>'text' <> 'coronavirus'
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;
