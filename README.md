Getting and Cleaning.Data - Course Project 
=========================

### Functions
- read.table.exists: Returns a data frame from a given file, stops the script if file doesn't exists
- make.df: make data frame from a data set (test , train) naming the columns subject, data set, activity, activity-name and features measures

### Main script
- Declare variable names
- Make data frames from features and activities. Columns named by id and name
- tidy.df.names is a vector containning the names of tidy data set 
- Make data frame from test data set using make.df function
- Make data frame from train data set using make.df function
- Make one data frame from test and data data frames (tidy.df)
- Drop the measures columns wich are not mean or std
- Save tidy.df to file
- Make new data frame for the mean of the measures group by subject, activity and activity name (keeping activity = id , for  further use) (tidy.avgs.file)
- Save tidy.avgs.file to file

