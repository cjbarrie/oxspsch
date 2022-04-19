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


# note difference in structure of payload

tweetsblm <- readRDS("data/blmtweets.rds")
tweetsblmb <- bind_tweets("data/json_data/", output_format = "tidy")

str(tweetsblmb)
str(tweetsblm)

# querying by user

tweetscjb <- get_all_tweets(
  user = "cbarrie",
  start_tweets = "2015-01-01T00:00:00Z",
  end_tweets = "2020-01-05T00:00:00Z",
  bearer_token = get_bearer(),
  file = "data/cjbtweets.rds",
  n = 500
)


# get user-level information

saveRDS(tweetscjb, "data/cjbtweets.rds")

tweetscjb <- readRDS("data/cjbtweets.rds")
id <- unique(tweetscjb$author_id)

prof <- get_user_profile(id)
saveRDS(prof, "data/cjbprof.rds")

# querying logics

tweets <-
  get_all_tweets(
    query = c("happy", "new", "year"),
    start_tweets = "2019-12-31T10:00:00Z",
    end_tweets = "2020-01-01T10:00:00Z"
  )

# sampling by language and location

tweets_seatt <-
  get_all_tweets(
    query = "happy",
    start_tweets = "2019-12-31T10:00:00Z",
    end_tweets = "2020-01-01T10:00:00Z",
    country = "US", 
    place = "seattle",
    lang = "en",
    n = 500
  )

saveRDS(tweets_seatt, "data/tweets_seatt.rds")

# context annotations (doesn't work yet in academictwitteR)

# query <- "context:123.1484601166080081920" # Ukraine context annotator
# 
# get_all_tweets(
#   query = paste0("Ukraine ", query),
#   start_tweets = "2021-01-01T00:00:00Z",
#   end_tweets = "2020-01-01T01:00:00Z",
#   bearer_token = get_bearer(),
#   page_n = 100
# )

# but we can build our own call:

my_query <- "Ukraine context:123.1484601166080081920"

endpoint_url <- "https://api.twitter.com/2/tweets/search/all"

params <- list(
  "query" = my_query,
  "start_time" = "2022-01-01T00:00:00Z",
  "end_time" = "2022-04-17T23:59:59Z",
  "max_results" = 20
)

r <- httr::GET(url = endpoint_url,
               httr::add_headers(
                 Authorization = paste0("bearer ", Sys.getenv("TWITTER_BEARER"))),
               query = params)

httr::content(r, as = "text")
