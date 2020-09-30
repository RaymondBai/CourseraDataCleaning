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
activity_labels <- read.csv("activity_labels.txt", sep = " ", header = FALSE)
colnames(activity_labels) <- c("activity_id", "activity_name")
activity_chart <- mutate(activity_labels, activity_name = tolower(activity_name))
rm(activity_labels)

# read in two portions of the full data
setwd("~/Desktop/Coursera R/Getting:Cleaning Data/UCI HAR Dataset/test")
test_subjects <- read.table("subject_test.txt")
test_labels <- read.table("y_test.txt")
test_set <- read.table("X_test.txt")

setwd("~/Desktop/Coursera R/Getting:Cleaning Data/UCI HAR Dataset/train")
training_subjects <- read.table("subject_train.txt")
training_labels <- read.table("y_train.txt")
training_set <- read.table("X_train.txt")

# combine testing and training data
subject_ids <- rbind(test_subjects, training_subjects)
activity_labels <- rbind(test_labels, training_labels)
exp_data <- rbind(test_set, training_set)

#remove parts to avoid environment clustering
rm(test_subjects, test_labels, test_set,
   training_subjects, training_labels, training_set)

# change activity labels to actual activity names
for (i in 1:nrow(activity_labels)) {
    activity_labels[i,1] <- activity_chart[activity_labels[i,1],2]
}
rm(i, activity_chart)

# Get only measured mean and standard deviation data
df_data <- exp_data[,mean_or_std]
rm(exp_data)

# Combine three sets of data
full_data <- cbind(subject_ids, activity_labels, df_data)
colnames(full_data) <- c("subjectid", "activitylabel", relevant_features)
full_data <- arrange(full_data, subject_ids)

# set working directory back to normal
setwd("~/Desktop/Coursera R/Getting:Cleaning Data/CourseraDataCleaning")

# Calculate means
full_data <- group_by(full_data, subjectid, activitylabel)
tidy_data <- summarize_all(full_data, mean)
write.table(tidy_data, file = "tidydata.txt", row.names = FALSE)
