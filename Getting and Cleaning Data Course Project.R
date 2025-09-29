# run_analysis.R
# Coursera Getting and Cleaning Data - Course Project
# This script does the following:
# 1. Downloads and unzips the UCI HAR Dataset (if not already present)
# 2. Merges the training and the test sets to create one data set
# 3. Extracts only the measurements on the mean and standard deviation for each measurement
# 4. Uses descriptive activity names to name the activities in the data set
# 5. Appropriately labels the data set with descriptive variable names
# 6. Creates a second tidy data set with the average of each variable for each activity and each subject

# ----- 0. Settings -----
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "UCI_HAR_Dataset.zip"
data_dir <- "UCI HAR Dataset"

# ----- 1. Download & unzip if necessary -----
if (!file.exists(data_dir)) {
  if (!file.exists(zipfile)) {
    message("Downloading dataset...")
    download.file(url, destfile = zipfile, mode = "wb")
  }
  message("Unzipping dataset...")
  unzip(zipfile)
}

# ----- 2. Read data files -----
features <- read.table(file.path(data_dir, "features.txt"), stringsAsFactors = FALSE)
activity_labels <- read.table(file.path(data_dir, "activity_labels.txt"), stringsAsFactors = FALSE)

# Training data
subject_train <- read.table(file.path(data_dir, "train", "subject_train.txt"))
X_train <- read.table(file.path(data_dir, "train", "X_train.txt"))
y_train <- read.table(file.path(data_dir, "train", "y_train.txt"))

# Test data
subject_test <- read.table(file.path(data_dir, "test", "subject_test.txt"))
X_test <- read.table(file.path(data_dir, "test", "X_test.txt"))
y_test <- read.table(file.path(data_dir, "test", "y_test.txt"))

# Assign column names for feature measurements
colnames(X_train) <- features[, 2]
colnames(X_test)  <- features[, 2]

# Name subject and activity columns
colnames(subject_train) <- "subject"
colnames(subject_test)  <- "subject"
colnames(y_train) <- "activity"
colnames(y_test)  <- "activity"

# ----- 3. Merge training and test sets -----
train <- cbind(subject_train, y_train, X_train)
test  <- cbind(subject_test, y_test, X_test)
all_data <- rbind(train, test)
rm(train, test, X_train, X_test, y_train, y_test, subject_train, subject_test)

# ----- 4. Extract only mean() and std() measurements -----
# We select only columns that are means (mean()) or standard deviations (std()) as specified
feature_mask <- grepl("mean\\(\\)|std\\(\\)", features[, 2])
# We need to account for the first two columns: subject and activity
selected_columns <- c(TRUE, TRUE, feature_mask)
extracted <- all_data[, selected_columns]

# ----- 5. Use descriptive activity names -----
activity_labels_vec <- activity_labels[, 2]
extracted$activity <- factor(extracted$activity, levels = activity_labels[,1], labels = activity_labels_vec)

# ----- 6. Label dataset with descriptive variable names -----
names_extracted <- colnames(extracted)
# Clean names: remove parentheses, replace dashes, expand abbreviations
names_extracted <- gsub("\\()", "", names_extracted)
names_extracted <- gsub("-", "", names_extracted)
# Expand prefixes and abbreviations
names_extracted <- gsub("^t", "Time", names_extracted)
names_extracted <- gsub("^f", "Frequency", names_extracted)
names_extracted <- gsub("Acc", "Accelerometer", names_extracted)
names_extracted <- gsub("Gyro", "Gyroscope", names_extracted)
names_extracted <- gsub("Mag", "Magnitude", names_extracted)
# Fix duplicated 'BodyBody' typo
names_extracted <- gsub("BodyBody", "Body", names_extracted)
# Make mean/std more readable
names_extracted <- gsub("mean", "Mean", names_extracted)
names_extracted <- gsub("std", "STD", names_extracted)

colnames(extracted) <- names_extracted

# ----- 7. Create tidy dataset with the average of each variable for each activity and each subject -----
# Use aggregate (base R) to avoid external package dependencies
tidy_dataset <- aggregate(. ~ subject + activity, data = extracted, FUN = mean)
# Order by subject then activity
tidy_dataset <- tidy_dataset[order(tidy_dataset$subject, tidy_dataset$activity), ]

# ----- 8. Write tidy dataset to file -----
output_file <- "tidy_dataset.txt"
write.table(tidy_dataset, file = output_file, row.names = FALSE)
message(sprintf("Tidy dataset written to %s (in working directory).", output_file))

# End of script
