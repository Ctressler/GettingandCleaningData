# CodeBook

# Human Activity Recognition Using Smartphones Dataset

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of # the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated #using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, #therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the #time and frequency domain. See 'features_info.txt' for more details. 

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

 The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation
* mad(): Median absolute deviation 
* max(): Largest value in array
* min(): Smallest value in array
* sma(): Signal magnitude area
* energy(): Energy measure. Sum of the squares divided by the number of values. 
* iqr(): Interquartile range 
* entropy(): Signal entropy
* arCoeff(): Autorregresion coefficients with Burg order equal to 4
* correlation(): correlation coefficient between two signals
* maxInds(): index of the frequency component with largest magnitude
* meanFreq(): Weighted average of the frequency components to obtain a mean frequency
* skewness(): skewness of the frequency domain signal 
* kurtosis(): kurtosis of the frequency domain signal 
* bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
* angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

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
