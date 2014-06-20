library(data.table)
library(reshape2)

#Step 1: Load data 
#1a: Load raw data
subject_test <- read.table("./test/subject_test.txt", quote="\"")
X_test <- read.table("./test/X_test.txt", quote="\"")
y_test <- read.table("./test/y_test.txt", quote="\"")
subject_train <- read.table("./train/subject_train.txt", quote="\"")
X_train <- read.table("./train/X_train.txt", quote="\"")
y_train <- read.table("./train/y_train.txt", quote="\"")
features <- read.table("features.txt", quote="\"")
activity_labels <- read.table("activity_labels.txt", quote="\"")

#1b: load the name column from the following 2 files
feature_names <- features[,2]
activity_names <- activity_labels[,2]

#Step 2: Extracts only the measurements on the mean and standard deviation 
#        for each measurement. (point 2)
#2a: Label the test and train data sets
names(X_test)<-feature_names
names(X_train)<-feature_names

#2b: Extracts only the measurements on the mean and standard deviation
X_test<-X_test[,grepl("mean|std", feature_names)]
X_train<-X_train[,grepl("mean|std", feature_names)]

#Step 3: Describe data. (points 3 and 4)
#3a: bind the test and train data sets
data<-rbind(X_test, X_train)

#3b: add a column with the activities description and bind the 2 sets
y_test[,2]<-activity_names[y_test[,1]]
y_train[,2]<-activity_names[y_train[,1]]
activities<-rbind(y_test, y_train)

#3c: label the columns
names(activities)<-c("ActivityID", "ActivityLabel")

#3d: bind and label the subject names from the test and train files
subject<-rbind(subject_test, subject_train)
colnames(subject)<-"SubjectNumber"

#Step 4: Combine all three tables. (point 1)
alldata<-cbind(as.data.table(subject), activities, data)

#Step 5: Creates a second, independent tidy data set with the average of each 
#        variable for each activity and each subject. (point 5)

#5a: Calculate average of each variable for each activity and each subject
id_labels<-c("SubjectNumber", "ActivityID", "ActivityLabel")
data_labels<-setdiff(colnames(alldata), id_labels)
predata<-melt(alldata, id = id_labels, measure.vars = data_labels)
result<-dcast(predata, SubjectNumber + ActivityLabel ~ variable, mean)

#5b: write the tidy dataset to a file
write.table(result, "tidydataset.txt",sep=";")
