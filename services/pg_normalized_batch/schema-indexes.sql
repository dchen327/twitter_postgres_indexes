CREATE INDEX idx_tag_idtweets ON tweet_tags(tag, id_tweets);
CREATE INDEX idx_idtweets_tag ON tweet_tags(id_tweets, tag);
CREATE INDEX idx_lang_idtweets ON tweets(lang, id_tweets);
CREATE INDEX idx_text_fts ON tweets USING GIN(to_tsvector('english', text));
CREATE INDEX idx_idtweets_lang ON tweets(id_tweets, lang);
