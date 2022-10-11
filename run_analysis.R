getwd()
library(data.table)
library(dplyr)
library(reshape2)
##Read Metadata##
activity_labels <- read.table("activity_labels.txt", header = FALSE)
featureNames <- read.table("features.txt")
##Read Train Data##
setwd("C:/Users/user/Documents/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train")
subjectTrain <- read.table("subject_train.txt", header = FALSE)
activityTrain <- read.table("y_train.txt", header = FALSE)
featuresTrain <- read.table("X_train.txt", header = FALSE)
##Read Test Data##
setwd("C:/Users/user/Documents/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test")
subjectTest <- read.table("subject_test.txt", header = FALSE)
activityTest <- read.table("y_test.txt", header = FALSE)
featuresTest <- read.table("X_test.txt", header = FALSE)

##Part1##
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)
colnames(features) <- t(featureNames[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)
##Part2##
columnswithmeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)
requiredColumns <- c(columnswithmeanSTD, 562, 563)
dim(completeData)
extractedData <- completeData[,requiredColumns]
dim(extractedData)

##Part3#3
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activity_Labels[i,2])
}
extractedData$Activity <- as.factor(extractedData$Activity)
##Part4#3
names(extractedData)
##Part5##
extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
