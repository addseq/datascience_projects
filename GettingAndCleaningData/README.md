Project for Getting and Cleaning Data Course

The R script attached:
- Requires the dplyr library for the final tidy dataset grouping and transformation
- Has optional commented code for downloading the dataset and unzipping into your working directory
- Helper functions merge_and_label(), filter_mean_std_cols() called in the main program is defined at the top

Project description from Course website:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

My approach:
- First download and read the files of interest: X_test.txt, y_test.txt, subject_test.txt, X_train.txt, y_train.txt, subject_train.txt, features.txt, actvity_labels.txt
- Use the merge_and_label() helper function to combine the dataset, labels, and subjects for both the test and train data. The function merges the activity names with the labels via V1 column, and then does a cbind to subjects to add all 3 extra label columns to dataset. This does both step 3 and 4 from project description above
- A rbind is then used to merge the labelled training and test sets, step 1 of project description
- A grepl() was used in helper function filter_mean_std_cols() to extract only std() and mean() columns (while keeping the label column from earlier step activityId, activityName, subjectId) to produce a filtered dataset, step 2 from project description
- The final step 5 from project description, I used group_by() and summarise_each() from the dplyr library to apply mean function on grouped fields, and write output to file.


