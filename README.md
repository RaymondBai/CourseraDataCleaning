This file explains the script DataCleaning.R

Line 1 loads dplyr package for future function usage

Lines 3-9 reads in features.txt, and finds the index of features that we want (mean or standard deviation). The vector of indices is stored as "mean_or_std". The actual vector of relevant features is stored as "relevant_features".

Lines 11-23 redefines the features in "relevant_features" by changing all upper-case letters to lower case, removing all parentheses, and expanding abbreviated/unclear variables. Underscore inserted where necessary to avoid clustering.

Lines 25-29 creates an an "activity_chart" (data frame) that matches each activity number (1-6) with its corresponding activity name.

Lines 31-40 read in all parts from the training and testing set

Lines 42-45 combine training and testing data to one "exp_data"

Lines 51-54 utilizes the previously created "activity_chart" to convert activity labels to the actual activity names (for clarity)

Lines 57-58 take a subset of the "exp_data" data frame to create "df_data" where data only concerns mean or standard deviation

Lines 61-72 combine all data columns to form the complete clean data. group_by and summarize_all are used find mean corresponding to each unique combination of subject_id and activity. The final tidy data set is written as a txt file.

* Lines 9, 29, 48-49, 55, 59 involve rm() to remove unneeded variables to avoid environment clustering.
