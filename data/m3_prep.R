# ----
# PREPARE DATA FOR M3 ALGORITHM TO PREDICT USER DEMOGRAPHICS
# ---

library(tidyverse)


#load user profile data
load("PATHTODATA/FILE.rds")

# Select relevant information
users_profile_data <- users_profile_data %>%
  dplyr::select(user_id, name, screen_name, description, lang, profile_image_url) %>%
  mutate(profile_image_url = str_replace_all(profile_image_url, "_normal", "_400x400"),
         img_raw = paste0("M3/user_profile_pics/raw_pic/", screen_name, "_400x400.jpg"))

# Get users profile pictures
for(i in seq_along(users_profile_data$img_raw)){
  if(file.exists(users_profile_data$img_raw[[i]])) {
    print("File already downloaded")  # skip if already downloaded
  } else {
    url <- as.character(users_profile_data$profile_image_url[[i]])
    
    # if multiple urls, only use first
    url <- strsplit(url," ")[[1]][1]
    
    # name jpg using tweet id
    destination <- users_profile_data$img_raw[[i]]
    
    # download files: 
    error <- tryCatch(download.file(url, destination, mode="wb"), 
                      error=function(e) e)
    if (inherits(error, 'error')) {
      cat("Error! Unable to download image...")
      next
    }
  }
}



# SAVE FILES ----------------------------------------------------------------------------------

# save as CSV file
users_profile_data <- users_profile_data %>%
  mutate(img_path = paste0("user_profile_pics/pic_resized/", screen_name, "_400x400.jpeg")) %>%
  rename(id = user_id) %>%
  # language cannot be undefined. Better to be computed by M3 directly, but for now prespecify
  mutate(lang = "en")


# for those with no profile picture, replace with default profile pic
for(i in seq_along(users_profile_data$img_raw)){
  if(!file.exists(users_profile_data$img_raw[[i]])) {
    users_profile_data$img_path[[i]] <- "user_profile_pics/pic_resized/default_profile_400x400.jpg"
  } 
}

### PYTHON CODE:
# to resize all images, navigate to current working directory/M3/ in terminal, then run: 
# python scripts/preprocess.py --source_dir user_profile_pics/raw_pic/ --output_dir user_profile_pics/pic_resized/ 


# CHECK WHICH PHOTOS WERE NOT RESIZED, and manually resize to 400x400
for(i in seq_along(users_profile_data$img_raw)){
  img_path <- paste0("M3/", users_profile_data$img_path[[i]])
  if(!file.exists(img_path)){
    print(img_path)
  } 
}
# save data
write_csv(users_profile_data, "M3/data/user_input_raw.csv")
# save as JSON LINES file
jsonlite::stream_out(users_profile_data, file('M3/data/user_input_raw.jsonl'))

### PYTHON CODE:
# navigate to current working directory/M3/ in terminal, then run: 
# python scripts/preprocess.py --source_dir user_profile_pics/raw_pic/ --output_dir user_profile_pics/pic_resized/ --jsonl_path data/user_input_raw.jsonl --jsonl_outpath data/user_input_resized.jsonl --verbose



