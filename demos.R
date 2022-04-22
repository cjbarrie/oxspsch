library(academictwitteR)
library(tidyverse)

bearer_object <- "AGDHFBCEWFUBVSDUBFVEKWHBRFVKHERBIFYEB"

tweetsimmi <- get_all_tweets(
  query = c("immigrant"), 
  start_tweets = "2010-01-01T00:00:00Z",
  end_tweets = "2010-03-31T00:00:00Z",
  country = "US",
  place = c("arizona OR nevada"),
  bearer_token = bearer_object,
  n = 1000
)