
##function to read table from file x, if exists return data frame
read.table.exists <- function (x,header = FALSE) {
  if (!file.exists(x)) {
    stop(paste("file", file.path(mainDir,x),"does not exists"))
  } else {
    read.table(x,header)
  }
}

##make data frame from datasets naming the columns
##columns 1:5
##1 subject
##2 activity
##3 activity-name 
##4 data set
make.df <- function (dataset,colnames) {
  subject <- paste(file.path(subDir,dataset),"/subject_",dataset,".txt",sep="")
  y <- paste(file.path(subDir,dataset),"/y_",dataset,".txt",sep="")
  X <- paste(file.path(subDir,dataset),"/X_",dataset,".txt",sep="")
  df <-cbind(read.table.exists(subject),read.table.exists(y),read.table.exists(y),c(dataset),read.table.exists(X))
  names(df) <- colnames
  df$"activity-name"<- activities.df[df$"activity-name",]$name
  df
}

##variables names
mainDir <- getwd()
subDir <- "UCI HAR Dataset"
data.local.file<-"UCI HAR Dataset.zip"
tidy.dataset.file <- "tidy-dataset.txt"
tidy.datasetavg.file <- "tidy-dataset-avg.txt"

##features data frame with named columns
features.df <- read.table.exists(file.path(subDir,"features.txt"))
names(features.df)  <- c("id","name")

##activities.df data frame with named columns
activities.df <- read.table.exists(file.path(subDir,"activity_labels.txt"))
names(activities.df)<-c("id","name")

tidy.df.names <- c("subject","activity","activity-name","dataset",as.vector(features.df$name))

##test data frame
test.df <- make.df("test",tidy.df.names)

##train data frame
train.df <- make.df("train",tidy.df.names)

##combine test and train 
tidy.df <- rbind(test.df,train.df)

##drop columns not *mean* or *std*
drop <- c()
keep <- c()
for (i in 5:ncol(tidy.df)) {
  colname<-names(tidy.df[i])
  if ( ( grepl("-mean",colname) |  grepl("-std",colname) ) ) {
    keep <-c(keep,names(tidy.df[i]))  
  }
  else {
    drop <-c(drop,names(tidy.df[i]))  
    
  }
}

tidy.df <- tidy.df[,!(names(tidy.df) %in% drop)]

write.csv(tidy.df, tidy.dataset.file)

##means for measures (from col 5 to total cols), group by: subject,activity,activity-name
tidy.avgs.df <- aggregate(tidy.df[, 5:dim(tidy.df)[2]],
                          list(subject=tidy.df$subject,
                               activity=tidy.df$activity,
                               "activity-name"=tidy.df$"activity-name"),
                          mean)

write.csv(tidy.avgs.df, tidy.datasetavg.file)

##return tidy data set
tidy.df
