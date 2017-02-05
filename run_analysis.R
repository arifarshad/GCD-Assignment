# Test for directory and create if need be
if(!file.exists("UCI HAR Dataset")){
  dir.create("UCI HAR Dataset")
}
# Download and unzip
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url = url, destfile = "./UCI HAR Dataset", method = "curl")
unzip("getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")


#Read first level data--activity and features.  Vectorize for extraction.  
#This will be used for extracting the rows needed and for the creation of factor columns in the end.
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
featurestoextract <- features[,2]
featurestoextract <- as.character(featurestoextract)
activity_labels_char <- as.character(features[,2])


#Extract names with mean and standard deviation.
#Will result in a vector of row numbers and a vector of names.
extracted_features <- grep((".*mean.*|.*std.*"), featurestoextract)
extracted_features_names <- features[extracted_features, 2]
extracted_features_names <- as.character(extracted_features_names)


# Read and keep only those columns that contain 'mean' or 'standard deviation'.
# Merge the tables to create 'train' and 'test' respectively
library(data.table)
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x_train <- x_train[, {seq_along(extracted_features)}]
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subject_train, y_train, x_train)
colnames(train) <- c("subject", "activity", extracted_features_names)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x_test <- x_test[, {seq_along(extracted_features)}]
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subject_test, y_test, x_test)
colnames(test) <- c("subject", "activity", extracted_features_names)


# Join merged datasets of train and test by row since we are adding to the observations
trainandtest <- rbind(train,test)


# Add names of variables to completely merged data
colnames(trainandtest) <- c("subject", "activity", extracted_features_names)

# First two columns are factors.  Convert to factors and add both levels and labels.
trainandtest[,1] <- as.factor(trainandtest[,1])
trainandtest[,2] <- factor(trainandtest[,2], levels = activity_labels[,1], labels = activity_labels[,2])

# Use package reshape2 to melt and cast a new data frame that finds the mean by subject and activity
library(reshape2)
trainandtest_melt <- melt(trainandtest, id = c("subject", "activity"))
trainandtest_means <- dcast(trainandtest_melt, subject + activity ~ variable, mean)

# Convert back to a csv file for submission as a dataset
write.table(trainandtest_means, file = "./GitHub/GCD-Assignment/tidydataset.txt", row.name = FALSE)



