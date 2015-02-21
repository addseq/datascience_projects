install.packages("dplyr")
library(dplyr)

# Function to merge and add activity/subject labels to train or test datasets
merge_and_label <- function(dataset, labels, subjects, features, activity_codes) {
    colnames(dataset) <- features$V2
    full_labels <- cbind( merge(labels, activity_codes, by.labels="V1"), subjects )
    colnames(full_labels) <- c("activityId", "activityName", "subjectId")
    merged_set <- cbind(dataset, full_labels)
    return(merged_set)
}

# Function to search for columns with mean() or std(), and keep the activity/subject columns
filter_mean_std_cols <- function(dataset) {
    search_pattern <- "-mean\\(\\)|-std\\(\\)|activityId|activityName|subjectId"
    mean_std_index <- grepl( search_pattern, names(dataset), ignore.case=TRUE)
    filtered_dataset <- dataset[,mean_std_index]
    return(filtered_dataset)
}

# Download and unzip the file, uncomment to download
#fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#zipFileLocal <- paste( c(getwd(), "/GCDProject.zip"), collapse = "" )
#download.file(fileURL, destfile = zipFileLocal, method = "curl")
#unzip( zipFileLocal, unzip = "internal")

# Read the test and train data
test_set <- read.table("UCI HAR Dataset/test/X_test.txt")
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
train_set <- read.table("UCI HAR Dataset/train/X_train.txt")
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
features <- read.table("UCI HAR Dataset/features.txt")
activity_codes <- read.table("UCI HAR Dataset/activity_labels.txt")

# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
merged_test_set <- merge_and_label(test_set, test_labels, test_subjects, features, activity_codes)
merged_train_set <- merge_and_label(train_set, train_labels, train_subjects, features, activity_codes)

# Merges the training and the test sets to create one data set.
merged_set <- rbind(merged_test_set, merged_train_set)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
filtered_set <- filter_mean_std_cols(merged_set)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
grouped_tidy_set <- group_by(filtered_set, activityId, activityName, subjectId) %>% summarise_each(funs(mean))
write.table(grouped_tidy_set, "grouped_tidy_set.txt", row.name=FALSE)
