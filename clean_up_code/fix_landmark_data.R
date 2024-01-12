# Fix error in landmark.csv file for California Transect study
# Joel Swift 1/12/2024

library(tidyverse)

# Read data
landmark_df <- read_csv("../landmark_data.csv")
landmark_df$id <- as.factor(landmark_df$id)
 
# find ids with duplicate entries
landmark_df %>%
  count(id) %>%
  filter(n > 63)
# All have 126 landmarks and are identical 
# 1-63 == 64-126

# Non duplicate 
Without_dups <- landmark_df %>%
  filter(!id %in% c("C_174", "C_235", "C_25", "C_291",
                   "C_292", "C_293", "C_294", "C_31",
                   "C_32", "C_420"))
# 34209 rows Sanity check
  
# Duplicates
Dups <- landmark_df %>%
  filter(id %in% c("C_174", "C_235", "C_25", "C_291",
                    "C_292", "C_293", "C_294", "C_31",
                    "C_32", "C_420"))
#1260 rows Sanity check

Deduped <- Dups %>%
  group_by(id) %>%
  slice(-c(64:126))
#630 rows
  
# combine and reorder the Order column 1 to length
Cleaned_landmark_df <- rbind(Without_dups,Deduped)
Cleaned_landmark_df$order <- 1:length(Cleaned_landmark_df$order)

# Export
write.csv(x = Cleaned_landmark_df, file = "../Cleaned_landmark_data.csv", row.names = FALSE)