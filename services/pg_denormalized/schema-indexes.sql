CREATE INDEX idx_all_hashtags_array ON public.tweets_jsonb USING gin (
  (
    COALESCE((data -> 'entities' -> 'hashtags'), '[]'::jsonb) ||
    COALESCE((data -> 'extended_tweet' -> 'entities' -> 'hashtags'), '[]'::jsonb)
  )
);

CREATE INDEX idx_data_id ON public.tweets_jsonb USING btree (
  (data ->> 'id')
);

CREATE INDEX idx_data_lang ON public.tweets_jsonb USING btree (
  (data ->> 'lang')
);

CREATE INDEX idx_data_text_fts ON public.tweets_jsonb USING gin (
  to_tsvector(
    'english',
    COALESCE((data -> 'extended_tweet' ->> 'full_text'), (data ->> 'text'))
  )
);
