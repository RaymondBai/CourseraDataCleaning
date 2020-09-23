This file explains the script DataCleaning.R


Line 1 loads dplyr package for future function usage

Lines 3-9 reads in features.txt, and finds the index of features that we want (mean or standard deviation). The vector of indices is stored as "mean_or_std". The actual vector of relevant features is stored as "relevant_features".

Lines 11-23 redefines the features in "relevant_features" by changing all upper-case letters to lower case, removing all parentheses, and expanding abbreviated/unclear variables. Underscore inserted where necessary to avoid clustering.

Lines 25-41 creates an an "activity_chart" (data frame) that matches each activity number (1-6) with its corresponding activity name.

Lines 44-53 read in all parts from the training and testing set

Lines 58-61 combine training and testing data to one "exp_data"

Lines 67-70 utilizes the previously created "activity_chart" to convert activity labels to the actual activity names (for cvlarity)

Line 73-81 loops through every line of data string given in the file, takes out excessive spaces before splitting it into a vector of numbers.

Line 82 then filters out non-mean/std data values

Line 83-87 eliminates excess zeros so the scientific notation is recognized in the process of coercion. The vector is then added to the data frame.

Line 90-99 combines all data columns to form the complete clean data. group_by and summarize_all are used find mean corresponding to each unique combination of subject_id and activity. The final tidy data set is written as a csv file.

* Lines 9, 42, 64, 65, 71, 88 involve rm() to remove unneeded variables to avoid environment clustering.
