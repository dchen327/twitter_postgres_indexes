CREATE INDEX idx_idtweets_tag ON public.tweet_tags USING btree (id_tweets, tag);
CREATE INDEX idx_tweet_tags_idtweets ON public.tweet_tags USING btree (id_tweets);
CREATE INDEX idx_idtweets_lang ON public.tweets USING btree (id_tweets, lang);
CREATE INDEX idx_lang_idtweets ON public.tweets USING btree (lang, id_tweets);
CREATE INDEX idx_text_fts ON public.tweets USING gin (to_tsvector('english'::regconfig, text));
CREATE INDEX idx_tweets_lang ON public.tweets USING btree (lang);
