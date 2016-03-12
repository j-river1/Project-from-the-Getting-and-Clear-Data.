##Download the dataset

library(reshape2)
filezip <- "cellphones.zip"

if(!file.exists(filezip))
	{
	fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	download.file(fileUrl, destfile="cellphones.zip", method ="auto")
	}

## Unzip the dataset
if (!file.exists("UCI HAR Dataset")) 
	{ 
  	unzip("cellphones.zip") 
	}
## Download type of activity, convert to type character and put new names 

Labels.Activity <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(Labels.Activity) <- c("Subject","Activity")
Labels.Activity[,2] <- as.character(Labels.Activity[,2])

## Download features, convert to type character and put column names

Features <-read.table("UCI HAR Dataset/features.txt")
colnames(Features) <- c("NumberMedition","Medition")
Features[,2] <- as.character(Features[,2])

## Find the desviation standar and mean

features_mean <- grep("\\bmean()\\b", Features$Medition)
features_std <- grep("\\bstd()\\b", Features$Medition)
features_total <- sort(c(features_mean, features_std ))
features_total_names <- Features[features_total,2]

##Clear the () and -

features_total_names <- gsub('-std','Std', features_total_names)
features_total_names <- gsub('-mean','Mean', features_total_names)
features_total_names <- gsub('[-()]','', features_total_names)

#Load the datasets

train     <- read.table("UCI HAR Dataset/train/X_train.txt")[features_total]
train_Activi <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_NumPer <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_NumPer, train_Activi, train)

test     <- read.table("UCI HAR Dataset/test/X_test.txt")[features_total]
test_Activi <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_NumPer <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_NumPer, test_Activi, test)

#merge the dataset

Merge_data <- rbind(train, test)
colnames(Merge_data) <- c("Subject","Activity",features_total_names)

#Turn into factors
Merge_data$Activity <- factor(Merge_data$Activity, levels=Labels.Activity[,1], labels = Labels.Activity[,2])
Merge_data$Subject <- as.factor(Merge_data$Subject)

Merge_data.melte <- melt(Merge_data, id =c("Subject","Activity"))
Merge_data.mean <- dcast(Merge_data.melte, Subject + Activity ~ variable, mean)


write.table(Merge_data.mean, "tidy.txt", row.names= FALSE, quote= FALSE)