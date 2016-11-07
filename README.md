## README

The repository contains the R script called run_analysis.R, which takes the raw data from *Human Activity Recognition using Smartphones* experiment and transforms it into tidy data. The clean data has been written to a file called TidyData.txt also included in the repo.

The repo also contains the CodeBook, which describes the experiment, the variables, the data and the script that is used to 
transform the data.

## The following describes the work performed to clean up the data:

### 1) The test (X_test.txt) and training (X_train.txt) data sets were read using read.table and were combined into one dataframe (dataset)

testdataset <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/test/X_test.txt"))
trainingdataset <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/train/X_train.txt"))
dataset <- rbind(trainingdataset, testdataset)


### 2) The subject information for the test and training (subject_train.txt, subject_test.txt) sets were read and combined into one dataframe(subject)

subjecttrain <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/train/subject_train.txt"))
subjecttest <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/test/subject_test.txt")) 
subject <- rbind(subjecttrain,subjecttest)
colnames(subject) <- "Subject"


### 3) The training labels information (y_train.txt, y_test.txt) was read and combined into a dataframe (activity)

testactivity <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/test/y_test.txt"))
trainactivity <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/train/y_train.txt"))
activity <- rbind(trainactivity, testactivity)
colnames(activity) <- "ActivityNumber"

### 4) All three data frames above were combined into one using cbind function (alldataset)

subact <- cbind(subject,activity)
alldataset <- cbind(subact, dataset)

### 5) The features document (features.txt) was read into a dataframe which shows the information about the variables (features)

features <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/features.txt"))
colnames(features)<- c("FeatureNumber", "FeatureName")

colnames(dataset) <- features$FeatureName

### 6) The activity labels (activity_labels.txt) were read into a dataframe which shows the names of the six different activities in the experiment (activitylabels)

activitylabels <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/activity_labels.txt"))
colnames(activitylabels)<- c("ActivityNumber", "ActivityName")

### 7) Using the grep function, only the measurements on the mean and standard deviation were extracted from the data frame 'features' (meanstdfeatures) 

meanstdfeatures <- grep("mean[()](.*)|std[()](.*)", features$FeatureName, value=TRUE)
meanstdfeatures <- union(c("Subject", "ActivityNumber"), meanstdfeatures)


### 8) A subset of the dataframe (alldataset) was created to only include the variables on the mean and standard deviation from dataframe (meanstdfeatures). The resulting dataframe was called finaldataset.

finaldataset <- subset(alldataset,select=meanstdfeatures)

### 9) Using the gsub function descriptive names were given to the variables

names(finaldataset)<-gsub("std()", "SD", names(finaldataset))
names(finaldataset)<-gsub("mean()", "MEAN", names(finaldataset))
names(finaldataset)<-gsub("^t", "time", names(finaldataset))
names(finaldataset)<-gsub("^f", "frequency", names(finaldataset))
names(finaldataset)<-gsub("Acc", "Accelerometer", names(finaldataset))
names(finaldataset)<-gsub("Gyro", "Gyroscope", names(finaldataset))
names(finaldataset)<-gsub("Mag", "Magnitude", names(finaldataset))
names(finaldataset)<-gsub("BodyBody", "Body", names(finaldataset))

### 10) A new column in the finaldataset data frame was created called 'combined' which was a numeric combination of the subject and activity number, e.g. for subject 1 and activity 5, the value was 15

finaldataset$combined <- paste(finaldataset$Subject, finaldataset$ActivityNumber, sep='')
finaldataset$combined <- as.numeric(finaldataset$combined)

### 11) The aggregate function was used to get the mean of all the columns in the dataframe based on the 'combined' column. This produced an average of each variable for the various trials for each subject and the activity. (average)

average<- aggregate(finaldataset, by=list(finaldataset$combined), FUN = mean)

### 12) The activitylabels dataframe was merged with average by the column 'ActivityNumber' to label the data set with descriptive activity names (finalaverage)

finalaverage <- merge(activitylabels, average, by="ActivityNumber", all.x = TRUE)

### 13) The additional columns 'combined' and 'Group.1" that were created were deleted from the dataframe and resulting dataframe was ordered by subject (NewAverage)

NewAverage <- finalaverage[ , !(names(finalaverage)) %in% c("Group.1","combined")]
NewAverage <- NewAverage[order(NewAverage$Subject),]

### 14) This final dataframe was written to a text file labelled TidyData.txt

write.table(NewAverage, "TidyData.txt", row.name=FALSE)
