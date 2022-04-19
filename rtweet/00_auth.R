library(rtweet)

# if (!requireNamespace("httpuv", quietly = TRUE)) {
#   install.packages("httpuv")
# }

## store api keys (these are fake example values; replace with your own keys)
api_key <- "XeL6Jgw2Mts50IqBQxA"
api_secret_key <- "LNWjDnUvf7yBJ6JfRo0YeDPZI2Mw2egXMNdatUOEEZrWp"
access_token <- "15163503639091ES81rbec0AgP0Xi7IN9Obi0slcEYd"
access_token_secret <- "a9n5eYOqVrJqHIVFRdulmtBznABWhd2YFilJHM"

## authenticate via web browser
token <- create_token(
  app = "bayesianresearch",
  consumer_key = api_key,
  consumer_secret = api_secret_key)

token

# Restart session
get_token()

rtweet::get_timeline(user = "cbarrie")


user <- "@jack"
jacktweets <- get_timeline(user, n = 50)
