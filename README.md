tidy_data
=========

Course Project for Getting and Cleaning Data from Coursera

# Summary

The `run_analysis.r` program uses data available from:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

as it is required by course project requirements: 1. Merges the training and the test sets to create one data set. 2. Extracts only the measurements on the mean and standard deviation for each measurement. 3. Uses descriptive activity names to name the activities in the data set 4. Appropriately labels the data set with descriptive variable names. 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Script
=======
## dependencies 

The `run_analysis.r` script will require `data.table` and `reshape2`.

## running

To run the downloaded data must be unpacked and in the local directory. The download should save as `UCI HAR Dataset`. The `run_analyis.r` script will look for `UCI HAR Dataset`. 

To run the script:

```source("run_analysis.r")
data <- tidy_data()
```

or you can explicitly direct to the folder that contains `UCI HAR Dataset`:

```
data <- tidy_data("tmp/data/UCI HAR Dataset")
```

## output

The out put of data will be a `data.table`. The contents of the data are described in depth in `CodeBook.md`.

Results can be saved to a `.txt` file as shown below:

```
write.table(data, file='tidy_data.txt')
```