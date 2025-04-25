/*
 * Count the number of tweets that use #coronavirus
 */
SELECT COUNT(DISTINCT data->>'id') AS cnt
FROM tweets_jsonb
WHERE
  (
    COALESCE(data->'entities'->'hashtags','[]')
    || COALESCE(data->'extended_tweet'->'entities'->'hashtags','[]')
  )
  @> '[{"text":"coronavirus"}]';
