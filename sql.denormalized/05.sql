/*
 * Calculates the hashtags that are commonly used for English tweets containing the word "coronavirus"
 */
WITH hits AS (
  SELECT data->>'id' AS id_tweets
  FROM tweets_jsonb
  WHERE
    to_tsvector('english',
      COALESCE(data->'extended_tweet'->>'full_text', data->>'text')
    ) @@ to_tsquery('english','coronavirus')
    AND data->>'lang' = 'en'
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
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;
