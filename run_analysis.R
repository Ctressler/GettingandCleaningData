temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp, mode="wb")
unzip(temp)
unlink(temp)
install.packages("dplyr")
library("dplyr")

!1)

subjecttrain <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/train/subject_train.txt"))
subjecttest <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/test/subject_test.txt")) 
subject <- rbind(subjecttrain,subjecttest)
colnames(subject) <- "Subject"

testdataset <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/test/X_test.txt"))
trainingdataset <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/train/X_train.txt"))
dataset <- rbind(trainingdataset, testdataset)

testactivity <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/test/y_test.txt"))
trainactivity <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/train/y_train.txt"))
activity <- rbind(trainactivity, testactivity)
colnames(activity) <- "ActivityNumber"

features <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/features.txt"))
colnames(features)<- c("FeatureNumber", "FeatureName")

colnames(dataset) <- features$FeatureName

activitylabels <- tbl_df(read.table("C:/Users/User/Desktop/Week 4/UCI HAR Dataset/activity_labels.txt"))
colnames(activitylabels)<- c("ActivityNumber", "ActivityName")

subact <- cbind(subject,activity)
alldataset <- cbind(subact, dataset)

!2)
meanstdfeatures <- grep("mean[()](.*)|std[()](.*)", features$FeatureName, value=TRUE)
meanstdfeatures <- union(c("Subject", "ActivityNumber"), meanstdfeatures)
finaldataset <- subset(alldataset,select=meanstdfeatures)

!3)

!finaldataset <- merge(activitylabels, finaldataset, by="ActivityNumber", all.x = TRUE)

!4)
names(finaldataset)<-gsub("std()", "SD", names(finaldataset))
names(finaldataset)<-gsub("mean()", "MEAN", names(finaldataset))
names(finaldataset)<-gsub("^t", "time", names(finaldataset))
names(finaldataset)<-gsub("^f", "frequency", names(finaldataset))
names(finaldataset)<-gsub("Acc", "Accelerometer", names(finaldataset))
names(finaldataset)<-gsub("Gyro", "Gyroscope", names(finaldataset))
names(finaldataset)<-gsub("Mag", "Magnitude", names(finaldataset))
names(finaldataset)<-gsub("BodyBody", "Body", names(finaldataset))

!5)

finaldataset$combined <- paste(finaldataset$Subject, finaldataset$ActivityNumber, sep='')
finaldataset$combined <- as.numeric(finaldataset$combined)

average<- aggregate(finaldataset, by=list(finaldataset$combined), FUN = mean)
finalaverage <- merge(activitylabels, average, by="ActivityNumber", all.x = TRUE)
NewAverage <- finalaverage[ , !(names(finalaverage)) %in% c("Group.1","combined")]
NewAverage <- NewAverage[order(NewAverage$Subject),]
write.table(NewAverage, "TidyData.txt", row.name=FALSE)
