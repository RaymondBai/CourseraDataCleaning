library(dplyr)

# read in all the feature names and pick out only mean/std ones
setwd("~/Desktop/Coursera R/Getting:Cleaning Data/UCI HAR Dataset")
features <- read.csv("features.txt", header = FALSE, sep = " ")
features <- features[,2]
mean_or_std <- grep("mean()|std()", features)
relevant_features <- features[mean_or_std]
rm(features)

# Clarify variable names using all lower case convention
# Also using underscore to prevent clustering
relevant_features <- gsub("^t", "time_", relevant_features)
relevant_features <- gsub("^f", "frequency_", relevant_features)
relevant_features <- tolower(relevant_features)
relevant_features <- gsub("-", "_", relevant_features)
relevant_features <- gsub("\\()", "", relevant_features)
relevant_features <- gsub("_body", "_body_", relevant_features)
relevant_features <- gsub("acc", "_acceleration_", relevant_features)
relevant_features <- gsub("mag", "_magnitude_", relevant_features)
relevant_features <- gsub("jerk", "_jerk_", relevant_features)
relevant_features <- gsub("(_){2,}", "_", relevant_features)
relevant_features <- gsub("body_body_", "body_body", relevant_features)


# Create an activity label chart (matching number and activity name)
activity_labels <- read.csv("activity_labels.txt", header = FALSE)
activity_labels <- activity_labels$V1
activity_vec <- unlist(strsplit(activity_labels, split = " "))
rm(activity_labels)
activity_num <- numeric()
activity_name <- character()
for (i in 1:length(activity_vec)) {
    if (i%%2 != 0){
        activity_num <- append(activity_num, as.numeric(activity_vec[i]))
    }
    if (i%%2 == 0){
        activity_name <- append(activity_name, activity_vec[i])
    }
}
activity_chart <- data.frame(activity_num, tolower(activity_name))
colnames(activity_chart) <- c("label", "activity")
rm(i, activity_vec, activity_num, activity_name)