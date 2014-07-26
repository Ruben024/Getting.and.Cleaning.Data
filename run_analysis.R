#variables names
subdir <- "UCI HAR Dataset"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
localzip <-"data.zip"
tidy.datasetavg.file <- "tidy-dataset-avg.txt"

#download and unzip file if necessary
if ( !file.exists(subdir) )  {
    download.file(url,destfile=localzip)
    unzip(localzip)
}

#features data frame with named columns
features.df <- read.table("UCI HAR Dataset/features.txt", header=FALSE)
names(features.df) <- c("id","name")

#activities data frame with named columns
activities.df <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE)
names(activities.df)<-c("id","name")

#one subject data frame from the two data sets and columns
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE)
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE)
subject<-rbind(subject_test,subject_train)
names(subject)<-c("subject")

#one y (activities) data frame from the two data sets and columns
y_test<-read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE)
y_train<-read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE)
y<-rbind(y_test,y_train)
##3.Uses descriptive activity names to name the activities in the data set
names(y)<-c("activity")
y$activity<-activities.df[y$activity,]$name

##one X (measurements) data frame from the two data sets and columns
X_test<-read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)
X_train<-read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE)
X<-rbind(X_test,X_train)

##4. Appropriately labels the data set with descriptive variable names. 
names(X)<-features.df$name

##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
X<-X[grepl("-mean|-std",names(X))] 

##1. Merges the training and the test sets to create one data set.
tidy.df<-cbind(subject,y,X)



##means for measures (measures go from 3th to last column), group by: subject,activity
#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
tidy.avgs.df <- aggregate(tidy.df[, 3:dim(tidy.df)[2]],
                          list(subject=tidy.df$subject,
                               activity=tidy.df$activity),
                          mean)

write.csv(tidy.avgs.df, tidy.datasetavg.file)
