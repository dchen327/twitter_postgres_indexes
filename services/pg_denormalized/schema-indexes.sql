CREATE INDEX idx_all_hashtags_array
ON public.tweets_jsonb
USING gin (
  (
    COALESCE((data -> 'entities'::text) -> 'hashtags'::text, '[]'::jsonb)
    ||
    COALESCE(((data -> 'extended_tweet'::text) -> 'entities'::text) -> 'hashtags'::text, '[]'::jsonb)
  )
);

CREATE INDEX idx_data_hashtags_text
ON public.tweets_jsonb
USING gin (
  (
    COALESCE((data -> 'entities'::text) -> 'hashtags'::text, '[]'::jsonb)
    ||
    COALESCE(((data -> 'extended_tweet'::text) -> 'entities'::text) -> 'hashtags'::text, '[]'::jsonb)
  )
);

CREATE INDEX idx_data_id
ON public.tweets_jsonb
USING btree ((data ->> 'id'::text));

CREATE INDEX idx_data_lang
ON public.tweets_jsonb
USing btree ((data ->> 'lang'::text));

CREATE INDEX idx_data_text_fts
ON public.tweets_jsonb
USING gin (
  to_tsvector(
    'english'::regconfig,
    COALESCE(
      (data -> 'extended_tweet'::text) ->> 'full_text'::text,
      data ->> 'text'::text
    )
  )
);

CREATE INDEX idx_tweets_jsonb_all_hashtags
ON public.tweets_jsonb
USING gin (
  (
    COALESCE((data -> 'entities'::text) -> 'hashtags'::text, '[]'::jsonb)
    ||
    COALESCE(((data -> 'extended_tweet'::text) -> 'entities'::text) -> 'hashtags'::text, '[]'::jsonb)
  )
);
