baseWD <- getwd()

#downlading the data and unzipping it
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "UCI HAR Dataset.zip", quiet=TRUE)
unzip("UCI HAR Dataset.zip")
setwd("./UCI HAR Dataset/")

#creating different file folders for the two data sets
path1 <- "./test"
path2 <- "./train"

flist1 <- list.files(path1, "*txt$", full.names = TRUE)
flist2 <- list.files(path2, "*txt$", full.names = TRUE)

file.copy(flist1,"./")
file.copy(flist2,"./")

library(utils)
print

#reading all the files from the two folders created - test and train

activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")
features <- features["V2"]
features <- t(features)
subject_test <- read.table("subject_test.txt")
subject_train <- read.table("subject_train.txt")
X_test <- read.table("X_test.txt")

X_train <- read.table("X_train.txt")


y_test <- read.table("y_test.txt")
y_train <- read.table("y_train.txt")
print

setwd(baseWD); rm(baseWD)

rm(path1);rm(path2)
rm(flist1);rm(flist2)

#MERGING THE DATA FILES

#STEP 1: binding the data into columns
test_data <- cbind(subject_test,y_test, X_test)
train_data <- cbind(subject_train,y_train, X_train)
master_data <- rbind(test_data,train_data)

#Step 2: adding the column names
names(master_data) <- c("Subject","Activity",features)
master_data$Activity <- as.factor(master_data$Activity)

# Step 3: adding descriptive activity 
levels(master_data$Activity) <- activity_labels$V2

rm(features)
rm(subject_test); rm(X_test); rm(y_test)
rm(subject_train); rm(X_train); rm(y_train)
rm(test_data); rm(train_data)
rm(activity_labels)

# Extract mean and standard deviation 
inc_filter <- c("[Mm]ean\\(\\)","[Ss]td\\(\\)", "Subject", "Activity")
master_ms <- master_data[, grep(paste(inc_filter,collapse = "|"), names(master_data))]

#Subset and calculate mean for every column 
group_by <- c("Subject","Activity")
datadim <- dim(master_ms)
totcol <- datadim[2]
result_unsorted <- aggregate(master_ms[3:totcol], by=master_ms[group_by], FUN=mean)

result <- result_unsorted[with(result_unsorted, order(Subject, Activity)), ]

rm(master_data);rm(master_ms); rm(datadim); rm(totcol);
rm(inc_filter); rm(group_by); rm(result_unsorted)

write.table(result,file="Tidy_Data.txt",row.names = FALSE)
print


