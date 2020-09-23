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

# read in two portions of the full data
setwd("~/Desktop/Coursera R/Getting:Cleaning Data/UCI HAR Dataset/test")
test_subjects <- read.csv("subject_test.txt", header = FALSE)
test_labels <- read.csv("y_test.txt", header = FALSE)
test_set <- read.csv("X_test.txt", header = FALSE)

setwd("~/Desktop/Coursera R/Getting:Cleaning Data/UCI HAR Dataset/train")
training_subjects <- read.csv("subject_train.txt", header = FALSE)
training_labels <- read.csv("y_train.txt", header = FALSE)
training_set <- read.csv("X_train.txt", header = FALSE)

# set working directory back to normal
setwd("~/Desktop/Coursera R/Getting:Cleaning Data/CourseraDataCleaning")

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

# create data frame to contain recorded data in better format (90-100 s)
df_data <- data.frame()
for (i in 1:nrow(exp_data)) {
    row_i <- exp_data[i,1]
    row_i <- gsub(" {2}", " ", row_i)
    data_i <- unlist(strsplit(row_i, " "))
    if (data_i[1] == ""){
        data_i <- data_i[!(data_i %in% "")]
    }
    data_i <- data_i[mean_or_std]
    data_i <- gsub("-00", "-", data_i)
    data_i <- gsub("\\+000", "+0", data_i)
    data_i <- as.numeric(data_i)
    df_data <- rbind(df_data, data_i)
}
rm(i, row_i, data_i, exp_data, mean_or_std)

# Combine three sets of data
full_data <- cbind(subject_ids, activity_labels, df_data)
colnames(full_data) <- c("subjectid", "activitylabel", relevant_features)
full_data <- arrange(full_data, subject_ids)


# Calculate means
full_data <- group_by(full_data, subjectid, activitylabel)
tidy_data <- summarize_all(full_data, mean)
write.csv(tidy_data, file = "tidydata.csv")
