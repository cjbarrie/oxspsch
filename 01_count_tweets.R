library(academictwitteR)
library(ggplot2)
library(dplyr)
library(lubridate)
library(gganimate)
library(ggthemes)

#simple hogmanay

tweetcounts <- count_all_tweets(
  query = "Hogmanay",
  start_tweets = "2019-12-27T00:00:00Z",
  end_tweets = "2020-01-05T00:00:00Z",
  bearer_token = get_bearer(),
  granularity = "hour",
  n = 500
)

#reformat date
tweetcounts$time <-
  parse_date_time(tweetcounts$start, 
                  orders = "ymd HMS")

#plot 
tweetcounts %>% ggplot() +
  geom_line(aes(time, tweet_count))

saveRDS(tweetcounts, "data/hogmanay.rds")

ggsave("images/hogmanay.png", 
       width=200, height = 150, 
       dpi=300, units="mm", bg = "white")


# exact phrase counts
# see: https://knowyourmeme.com/memes/i-dont-know-who-needs-to-hear-this

tweetcounts <- count_all_tweets(
  query = "\"I don't know who needs to hear this\"",
  start_tweets = "2010-12-27T00:00:00Z",
  end_tweets = "2020-01-05T00:00:00Z",
  bearer_token = get_bearer(),
  granularity = "day",
  n = 5000
)

#reformat date
tweetcounts$time <-
  parse_date_time(tweetcounts$start, orders = "ymd HMS")

#plot 
tweetcounts %>% ggplot() +
  geom_line(aes(time, tweet_count))

saveRDS(tweetcounts, "data/idkcounts.rds")


# animate
p <- tweetcounts %>% ggplot() +
  geom_line(aes(time, tweet_count)) +
  # Here comes the gganimate specific bits
  transition_reveal(time) +
  ease_aes('linear') +
  theme_tufte(base_family = "Helvetica") +
  theme(legend.position = "none") + 
  labs(title = "Tweet counts for 'I don't know who needs to hear this'",
       x= "Day", y = "N. tweets")

anim_save("plots/idk.gif", p)

## Adding arguments

tweetcounts <- count_all_tweets(
  query = "Hogmanay",
  place = "Edinburgh",
  is_retweet = F,
  has_images = T,
  start_tweets = "2019-12-27T00:00:00Z",
  end_tweets = "2020-01-05T00:00:00Z",
  bearer_token = get_bearer(),
  granularity = "hour",
  n = 500
)

## Adding arguments (users)

tweetcounts <- count_all_tweets(
  query = "Hogmanay",
  users = "edhogmanay",
  start_tweets = "2019-12-27T00:00:00Z",
  end_tweets = "2020-01-05T00:00:00Z",
  bearer_token = get_bearer(),
  granularity = "day",
  n = 500
)

# saveRDS(tweetcounts, "data/edhogmanaycounts.rds")

## Normalizing

tweetcounts <- count_all_tweets(
  query = "immigration",
  start_tweets = "2015-12-27T00:00:00Z",
  end_tweets = "2020-01-05T00:00:00Z",
  bearer_token = get_bearer(),
  granularity = "day",
  n = 5000
)

# saveRDS(tweetcounts, "data/immigcounts.rds")
tweetcounts <- readRDS("data/immigcounts.rds")

baselinecounts <- count_all_tweets(
  query = "therefore",
  start_tweets = "2015-12-27T00:00:00Z",
  end_tweets = "2020-01-05T00:00:00Z",
  bearer_token = get_bearer(),
  granularity = "day",
  n = 5000
)

# saveRDS(baselinecounts, "data/baselinecounts.rds")
baselinecounts <- readRDS("data/baselinecounts.rds")

normalize_counts <- function(tweetcounts, baselinecounts) {
  tweetcounts <- tweetcounts$tweet_count
  baselinecounts <- baselinecounts$tweet_count
  normalized_counts <- tweetcounts/baselinecounts
  return(normalized_counts)
}

tweetcounts$normalized_count <-
  normalize_counts(tweetcounts = tweetcounts,
                   baselinecounts = baselinecounts)


tweetcounts$day <-
  parse_date_time(tweetcounts$start, 
                  orders = "ymd HMS")

tweetcounts %>% ggplot() +
  geom_line(aes(day, tweet_count)) +
  theme_tufte(base_family = "Helvetica") +
  theme(legend.position = "none") + 
  labs(title = "Immigration tweet counts",
       x= "Day", y = "N. tweets")

tweetcounts %>% ggplot() +
  geom_line(aes(day, normalized_count)) +
  theme_tufte(base_family = "Helvetica") +
  theme(legend.position = "none") + 
  labs(title = "Immigration tweet counts (normalized)",
       x= "Day", y = "N. tweets")

