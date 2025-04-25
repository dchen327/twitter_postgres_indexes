/*
 * Calculates the languages that use the hashtag #coronavirus
 */
SELECT
  data->>'lang' AS lang,
  COUNT(DISTINCT data->>'id') AS count
FROM tweets_jsonb
WHERE
  (
    COALESCE(data->'entities'->'hashtags','[]')
  || COALESCE(data->'extended_tweet'->'entities'->'hashtags','[]')
  ) @> '[{"text":"coronavirus"}]'
GROUP BY 1
ORDER BY count DESC, lang;
