library(dplyr)

# Read the Train data
train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Read the Test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Read Variable Names
variables_labs <- read.table("./UCI HAR Dataset/features.txt")

# Read Activities Names
activities_labs <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Merges the training and the test sets to create one single data set and measurements
# Gets mean and standard deviation, put labels
X <- rbind(train_x, X_test)
Y <- rbind(train_y, Y_test)
Sub_total <- rbind(subject_train, Sub_test)
measurements <- variables_labs[grep("mean\\(\\)|std\\(\\)",variables_labs[,2]),]
X <- X[,measurements[,1]]
colnames(Y) <- "Activity"
Y$activitylabel <- factor(Y$Activity, labels = as.character(activities_labs[,2]))
activitylabel <- Y[,-1]
colnames(X) <- variables_labs[measurements[,1],2]

# Creates a second tidy data with the average of each variable for each activity and subject.
colnames(Sub_total) <- "subject"
total <- cbind(X, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)