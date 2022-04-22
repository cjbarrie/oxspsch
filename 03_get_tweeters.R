library(academictwitteR)
library(ggplot2)
library(dplyr)

#hydrate tweets

tweet_IDs <- readRDS("data/wm_IDs_samp.rds")
head(tweet_IDs)

#throws an error still for some IDs (looking into this)
hydrated_tweets <- hydrate_tweets(tweet_IDs, errors = T,
                                  data_path = "data/hydrated_tweets/")

#use https://tweeterid.com/ to convert your username to an ID
#OR
#get user @cbarrie
get_user_id("cbarrie")
cjb_ID <- "95226101"

#find who he's following
userfwing <- get_user_following(cjb_ID)
# saveRDS(userfwing, "data/cjbfwing.rds")
# userfwing <- readRDS("data/cjbfwing.rds")
#get their IDs if you wanted to further analysis on the following network of @cbarrie
ids <- userfwing$id

#get the user metrics of whom @cbarrie is following
userfwing_metrics <- userfwing$public_metrics

#plot 
userfwing_metrics %>%
  ggplot() +
  geom_histogram(aes(log(followers_count)),
                 binwidth = .5)

ggsave("images/userfwing_hist.png", 
       width=200, height = 150, 
       dpi=300, units="mm", bg = "white")

# extensions
devtools::install_github("pablobarbera/twitter_ideology/pkg/tweetscores")
library(tweetscores)

results <- estimateIdeology("cbarrie", ids)
saveRDS(results, "data/cjbtscore.rds")
plot(results)

results <- estimateIdeology2("cbarrie", ids)

#or you can find user IDs in the collected tweets from before
#after using `bind_tweets()` with `output_format = "tidy"`
#where `author_id` is the user's tweeter ID

tweetsblmb <- bind_tweets("data/json_data/", output_format = "tidy")
blm_IDs <- unique(tweetsblmb$author_id)

# get friends for each of the tweeters
hist(log(tweetsblmb$user_following_count))
max(tweetsblmb$user_following_count)
blm_ids_sample <- sample(blm_IDs, 50)

fwinglist <- list()

for (i in seq_along(blm_ids_sample)) {
  id <- blm_ids_sample[[i]]
  userfwing <- get_user_following(id)
  userfwing <- userfwing[, c("id", "username")]
  fwinglist[[i]] <- userfwing
  names(fwinglist[i]) <- id
}

fwinglist <- setNames(fwinglist,blm_ids_sample)

saveRDS(fwinglist, "data/fwinglist.rds")

results <- data.frame()
for (i in seq_along(fwinglist)) {
  user <- names(fwinglist[i])
  friends <- fwinglist[[i]][["id"]]
  
  error <- tryCatch(result <- estimateIdeology2(user, friends),
                    error=function(e) e)
  if (inherits(error, 'error')) {
    cat("Error! User follows 0 elites \n")
    Sys.sleep(1)
    next
  } 
  
  results <- rbind(results, result)
}

colnames(results) <- "ideo"

hist(results$ideo, breaks = 20)

## geolocation inference

# userfwing <- readRDS("data/cjbfwing.rds")

userfwing %>%
  group_by(location) %>%
  summarise(count = n()) %>%
  top_n(count)
