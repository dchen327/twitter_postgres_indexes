CREATE INDEX idx_hashtags_coronavirus ON public.tweets_jsonb 
USING gin ((COALESCE((data -> 'entities'::text) -> 'hashtags'::text, '[]'::jsonb) || 
            COALESCE(((data -> 'extended_tweet'::text) -> 'entities'::text) -> 'hashtags'::text, '[]'::jsonb)))
WHERE ((COALESCE((data -> 'entities'::text) -> 'hashtags'::text, '[]'::jsonb) || 
        COALESCE(((data -> 'extended_tweet'::text) -> 'entities'::text) -> 'hashtags'::text, '[]'::jsonb))) @> '[{"text":"coronavirus"}]';

CREATE INDEX idx_corona_english_tweets ON public.tweets_jsonb
USING gin (to_tsvector('english'::regconfig,
           COALESCE((data -> 'extended_tweet'::text) ->> 'full_text'::text, data ->> 'text'::text)))
WHERE (data ->> 'lang'::text) = 'en';

CREATE INDEX idx_lang_coronavirus_hashtag ON public.tweets_jsonb
USING btree ((data ->> 'lang'::text))
WHERE ((COALESCE((data -> 'entities'::text) -> 'hashtags'::text, '[]'::jsonb) ||
        COALESCE(((data -> 'extended_tweet'::text) -> 'entities'::text) -> 'hashtags'::text, '[]'::jsonb))) @> '[{"text":"coronavirus"}]';
