/*
 * Calculates the hashtags that are commonly used with the hashtag #coronavirus
 */
SELECT
  '#' || uniq.tag_text AS tag,
  COUNT(*)             AS count
FROM (
  SELECT DISTINCT
    t.data->>'id'     AS id_tweets,
    jshtag->>'text'   AS tag_text
  FROM tweets_jsonb AS t
  CROSS JOIN LATERAL (
    VALUES (
      COALESCE(t.data->'entities'->'hashtags',    '[]'::jsonb)
    || COALESCE(t.data->'extended_tweet'->'entities'->'hashtags','[]'::jsonb)
    )
  ) AS arr(hashtags)
  CROSS JOIN LATERAL
    jsonb_array_elements(arr.hashtags) AS elem(jshtag)
  WHERE
    arr.hashtags @> $$[{"text":"coronavirus"}]$$
) AS uniq
GROUP BY
  uniq.tag_text
ORDER BY
  count DESC,
  uniq.tag_text
LIMIT 1000;
