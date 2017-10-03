#Load packages
library(plyr)
library(dplyr)
library(reshape2)

#Load test data set components
setwd("/Users/EZ/Documents/Data/Exercises/Coursera/GettingandCleaningData/assignment/UCI HAR Dataset/test")
subject_test<-read.csv("subject_test.txt", header = FALSE, stringsAsFactors = FALSE)
x_test<-scan("X_test.txt", what="", sep="\n")
y_test<-read.csv("y_test.txt", header = FALSE, stringsAsFactors = FALSE)
x_test1<-strsplit(x_test, "[[:space:]]+")

#Load train data set components
setwd("/Users/EZ/Documents/Data/Exercises/Coursera/GettingandCleaningData/assignment/UCI HAR Dataset/train")
subject_train<-read.csv("subject_train.txt", header = FALSE, stringsAsFactors = FALSE)
x_train<-scan("X_train.txt", what="", sep="\n")
y_train<-read.csv("y_train.txt", header = FALSE, stringsAsFactors = FALSE)
x_train1<-strsplit(x_train, "[[:space:]]+")

#Load activity labels
setwd("/Users/EZ/Documents/Data/Exercises/Coursera/GettingandCleaningData/assignment/UCI HAR Dataset")
act_labels<-read.table("activity_labels.txt", header = FALSE)
names(act_labels)<-c("number", "activity")

#Load features labels
feat<-read.table("features.txt", header = FALSE, stringsAsFactors = FALSE)
names(feat)<-c("featnum", "feature")
View(feat)
setwd("/Users/EZ/Documents/Data/Exercises/Coursera/GettingandCleaningData/assignment")

#Get only mean and standard deviation of each label
feat_vals<-grepl("mean|std",feat$feature)&!grepl("Freq",feat$feature)
mean_std<-c(FALSE, feat_vals)

#Parse each character containing values of variables into separate vector
x_test2<-vector("list", length(x_test1))
for (i in 1:length(x_test1)) {
  x_test2[[i]]<-x_test1[[i]][mean_std]
}
names(x_test2)<-1:length(x_test1)

x_train2<-vector("list", length(x_train1))
for (i in 1:length(x_train1)) {
  x_train2[[i]]<-x_train1[[i]][mean_std]
}
names(x_train2)<-(length(x_test1)+1):(length(x_train1)+length(x_test1))

#Convert into data frames
x_test2<-data.frame(x_test2)
x_test2<-t(x_test2)
x_train2<-data.frame(x_train2)
x_train2<-t(x_train2)
x_train2<-data.frame(x_train2)

#Replace integers with descriptive names for activity
y_test1<-act_labels[y_test[[1]],2]
y_train1<-act_labels[y_train[[1]],2]

#Merge test and train
merge_test<-cbind(subject_test, y_test1, x_test2)
merge_train<-cbind(subject_train, y_train1, x_train2)
names(merge_test)<-names(merge_train)
merge_both<-rbind(merge_test, merge_train)

#Change variable names to be descriptive
narrow_feat<-feat[feat_vals,2]
class(narrow_feat)<-"vector"

narrow_feat<-sub("mean","Mean", narrow_feat)
narrow_feat<-sub("std", "Std", narrow_feat)
narrow_feat<-sub("\\()", "", narrow_feat)
narrow_feat<-gsub("\\-", "", narrow_feat)
split_names<-strsplit(narrow_feat, "-")
vars<-sapply(split_names, function(x){x[1]})
names(merge_both)<-(c("subject", "activity", vars))

#Melt data frame and obtain mean for each subject, activity, and variable
melted<-melt(merge_both, id=c("subject", "activity"), measure.vars=vars)
class(melted$value)<-"numeric"
casted<-dcast(melted, subject + activity ~ variable, mean)


