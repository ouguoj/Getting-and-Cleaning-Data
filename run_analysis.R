## Download and unzip dataset 
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "Dataset.zip")
unzip("Dataset.zip")

##Read the relevant data files and assign each data file to a distinct object
train_x<-read.table("./UCI HAR Dataset/train/X_train.txt")
train_y<-read.table("./UCI HAR Dataset/train/y_train.txt")
train_subject<-read.table("./UCI HAR Dataset/train/subject_train.txt")

test_x<-read.table("./UCI HAR Dataset/test/X_test.txt")
test_y<-read.table("./UCI HAR Dataset/test/y_test.txt")
test_subject<-read.table("./UCI HAR Dataset/test/subject_test.txt")

activities<-read.table("./UCI HAR Dataset/activity_labels.txt", sep="")
features<-read.table("./UCI HAR Dataset/features.txt", sep="")

##Merge data into one big data set (datamerge dataframe) with appropriate labels
train_data<-cbind(train_x,train_subject,train_y)
test_data<-cbind(test_x,test_subject,test_y)
datamerge<-rbind(train_data,test_data)
colnames(datamerge)<-c(as.character(features[,2]),"Subject","Activity_Label")

##Extract the measurements on the mean and standard deviation for  each measurement
datamerge_mean_std<-datamerge[,grep("mean|std|Subject|Activity_Label",names(datamerge))]

##Use descriptive activity names to name the activities in the data set
colnames(activities)<-c("Activity_Label", "Activities")
datamerge_mean_std<-merge(datamerge_mean_std, activities, by="Activity_Label")

##Appropriately label the data set with descriptive variable names

names(datamerge_mean_std)<-gsub("^t", "Time", names(datamerge_mean_std))
names(datamerge_mean_std)<-gsub("^f", "Frequency", names(datamerge_mean_std))
names(datamerge_mean_std)<-gsub("Acc", "Acceleration", names(datamerge_mean_std))
names(datamerge_mean_std)<-gsub("Mag", "Magnitude", names(datamerge_mean_std))
names(datamerge_mean_std)<-gsub("std", "StandardDeviation", names(datamerge_mean_std))
names(datamerge_mean_std)<-gsub("\\()", "", names(datamerge_mean_std))

##Create a second, independent tidy data set with the average of each variable for each activity and each subject

data2<-aggregate(datamerge_mean_std, by=list(datamerge_mean_std$Activities, datamerge_mean_std$Subject), mean)
data2[,84]=NULL
data2[,83]=NULL
colnames(data2)[1]<-"Activities"
colnames(data2)[2]<-"Subject"

##Create a text file with the second data set using write.table
write.table(data2, "averagedata.txt", row.names = FALSE)
