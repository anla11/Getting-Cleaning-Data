setwd("E:/Workspace/R/R-coursera/Cleaning-Data/Wk4")

require("data.table")
require("reshape2")

#1. Reading train data and test data
features <- read.table("UCI-HAR-Dataset/features.txt")[,2]
labels <- read.table("UCI-HAR-Dataset/activity_labels.txt")

x_train <- read.table("UCI-HAR-Dataset/train/X_train.txt")
y_train <- read.table("UCI-HAR-Dataset/train/y_train.txt")
subject_train <- read.table("UCI-HAR-Dataset/train/subject_train.txt")

x_test <- read.table("UCI-HAR-Dataset/test/X_test.txt")
y_test <- read.table("UCI-HAR-Dataset/test/y_test.txt")
subject_test <- read.table("UCI-HAR-Dataset/test/subject_test.txt")

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

#Rename col of data
names(x) <- features
y <- merge(y, labels, by.x = "V1", by.y = "V1", all.x = TRUE)
names(y) <- c("Activity_ID", "Activity_Label")
names(subject) <- "Subject"


#Extracts only the measurements 
# on the mean and standard deviation for each measuremen.
extrFtrs <- grepl("mean|std", features)
extr_x <- x[, extrFtrs]

#merge data
dt <- cbind(subject, y, extr_x)

#select feature Subject, Activity_ID, Activity_Label
data_labels <- setdiff(colnames(dt), c("Subject", "Activity_ID", "Activity_Label"))
dt2 <- melt(dt, id = id_labels, measure.vars = data_labels)

#create tidy_data 
tidy_data <- dcast(dt2, Subject + Activity_Label ~ variable, mean)

#write data to Tidy.txt
write.table(tidy_data, file = "Tidy.txt", row.names = FALSE)

