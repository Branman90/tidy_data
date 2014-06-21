# Course project for 'Getting and Cleaning Data'
# This script  transforms the dataset avaliable from:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# data must be downloaded and unpacked into the local folder

library('data.table')
library('reshape2')

tidy_data <- function(data_folder='UCI HAR Dataset') {
        # Arugments: 
        #       data_folder: the path for the source data
        #
        # Returns:
        #       A tidy data set as requested in the course project requirments
        #       More info in README.md
        
        # Loading the common labels between the two datasets
        labels <- read.table(paste(data_folder, 'features.txt', sep='/'),
                             stringsAsFactors=FALSE)
        
        # Create a column mean to filter out mean and std. values
        columns <- grep("-(std|mean)\\(\\)", labels$V2)
        
        # nested function loading and transforming the data in a data.table
        read_data <- function(type){
                # Arugments:
                #       type: which dataset to use 'train' or 'test'
                fileName <- paste(data_folder, type,
                                  paste("X_", type, ".txt", sep=""),sep="/")
                rowData <- read.table(fileName)
                
                #leave only relevent columns
                d <- rowData[,columns]
                #set discriptive names to the columns
                setnames(d, labels[columns,2])
                
                #add subject column
                fileName <- paste(data_folder, type,
                                  paste("subject_", type, ".txt", sep=""),sep="/")
                subject <- fread(fileName)
                
                d$subject <- subject$V1
                
                #add activity column
                fileName <- paste(data_folder, type,
                                  paste("y_",type, ".txt", sep=""), sep="/")
                activity <- fread(fileName)
                
                d$activity <- activity$V1
                
                #transform the data.frame into a data.table, this will help speed 
                #up the merge and transformation
                as.data.table(d)
                
        }
        
        #read and combine the two datasets, this will be a data table
        data <- rbind(read_data('test'), read_data('train'))
        
        #replace the activity codes with descriptive names
        actlabels <- fread(paste(data_folder, "activity_labels.txt", sep="/"))
        data[,activity:= factor(data$activity,
                                levels=actlabels$V1,
                                labels=actlabels$V2)]
        
        #calculate the mean values of all columns
        #grouping by subject and activity fields.
        #result will be a data.table
        tidy <- data[,lapply(.SD,mean), by=c("activity","subject")]
        
        #reshape data set to create tidy narrow data set
        melt(tidy, id=c("activity","subject"), variable.name="feature", value.name="average")
        
}
