library(academictwitteR)
library(ggplot2)
library(dplyr)
library(lubridate)

# querying by string
tweetsblm <- get_all_tweets(
  query = "BLM",
  start_tweets = "2020-01-01T00:00:00Z",
  end_tweets = "2020-01-05T00:00:00Z",
  bearer_token = get_bearer(),
  file = "data/blmtweets.rds",
  data_path = "data/json_data/",
  n = 500
)

#get tidy format data
tweetsblmb <- bind_tweets("data/json_data/", output_format = "tidy")

#plot
tweetsblmb %>%
  ggplot() +
  geom_histogram(aes(log(retweet_count)),
                 binwidth = 1)

ggsave("images/blm_retweets.png", 
       width=200, height = 150, 
       dpi=300, units="mm", bg = "white")


# querying by user

tweetscjb <- get_all_tweets(
  user = "cbarrie",
  start_tweets = "2015-01-01T00:00:00Z",
  end_tweets = "2020-01-05T00:00:00Z",
  bearer_token = get_bearer(),
  file = "data/cjbtweets.rds",
  n = 500
)

# note difference in structure of payload
saveRDS(tweetscjb, "data/cjbtweets.rds")
tweetscjb <- readRDS("data/cjbtweets.rds")
tweetscjb$public_metrics

