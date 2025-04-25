/*
 * Calculates the hashtags that are commonly used for English tweets containing the word "coronavirus"
 */
SELECT
  '#' || uniq.tag_text AS tag,
  COUNT(*)            AS count
FROM (
  SELECT DISTINCT
    t.data->>'id'    AS id_tweets,
    jshtag->>'text'  AS tag_text
  FROM tweets_jsonb AS t
  -- assemble the full hashtags array
  CROSS JOIN LATERAL (
    VALUES (
      COALESCE(t.data->'entities'->'hashtags'               , '[]'::jsonb)
    || COALESCE(t.data->'extended_tweet'->'entities'->'hashtags', '[]'::jsonb)
    )
  ) AS arr(hashtags)
  -- explode into individual hashtag objects
  CROSS JOIN LATERAL
    jsonb_array_elements(arr.hashtags) AS elem(jshtag)
  WHERE
    to_tsvector(
      'english',
      COALESCE(
        t.data->'extended_tweet'->>'full_text',
        t.data->>'text'
      )
    ) @@ to_tsquery('english', 'coronavirus')
    AND t.data->>'lang' = 'en'
) AS uniq
GROUP BY
  uniq.tag_text
ORDER BY
  count DESC,
  uniq.tag_text
LIMIT 1000;
