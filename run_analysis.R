# Getting and Cleaning data course project

# Merges the training and the test sets to create one data set.

getwd()
dir.create("Week_4_Final_Project")
setwd("Week_4_Final_Project")
getwd()


# Q1 Merges the training and the test sets to create one data set.
# the libraries used are data.table, and dplyr

install.packages("data.table")
install.packages("dplyr")
library(data.table)
library(dplyr)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, destfile = "Week_4_Final_Project")

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")


X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# read data description

variable_names <- read.table("./UCI HAR Dataset/features.txt")

head(variable_names, n=2)
head(X_train, n = 2)

# read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)


# Q2 Extracts only the measurements on the mean and standard deviation for each measurement.


selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",
                                    variable_names[,2]), ]
View(selected_var)

X_total <- X_total[, selected_var[,1]]
dim(X_total)

# 3. Uses descriptive activity names to name the activities in the data set

colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]

activitylabel


# 4. Appropriately labels the data set with descriptive variable names.

colnames(X_total) <- variable_names[selected_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

