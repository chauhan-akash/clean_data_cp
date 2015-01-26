feat <- read.table("features.txt", row.names=NULL)
feat_name <- as.vector(as.character(feat$V2))
ac_lab <- read.table("activity_labels.txt", row.names=NULL)
names(ac_lab) <- c("labels", "labels_desc")

#get the training dataset ready

train <- read.table("train/X_train.txt", row.names=NULL)
names(train) <- feat_name

train1 <- train[,grep("mean()",names(train))]
train2 <- train[,grep("std()",names(train))]

train_lab <- read.table("train/y_train.txt", row.names=NULL)
names(train_lab) <- c("labels")
sub_train <- read.table("train/subject_train.txt", row.names=NULL)
names(sub_train) <- c("subjects")

train_lab <- merge(train_lab, ac_lab, by="labels")

train_name <- as.data.frame(rep("train",nrow(train)))
names(train_name) <- c("name")

train_final <- cbind(train1, train2, train_lab, sub_train, train_name)

#get the test dataset ready

test <- read.table("test/X_test.txt", row.names=NULL)
names(test) <- feat_name

test1 <- test[,grep("mean()",names(test))]
test2 <- test[,grep("std()",names(test))]

test_lab <- read.table("test/y_test.txt", row.names=NULL)
names(test_lab) <- c("labels")
sub_test <- read.table("test/subject_test.txt", row.names=NULL)
names(sub_test) <- c("subjects")

test_lab <- merge(test_lab, ac_lab, by="labels")

test_name <- as.data.frame(rep("test",nrow(test)))
names(test_name) <- c("name")

test_final <- cbind(test1, test2, test_lab, sub_test, test_name)

# appending both data sets into one

final_data <- rbind(test_final, train_final)

write.table(final_data,"final_data.csv", sep=",", row.names=FALSE)

# calculating averages of all variables by subject and activity

final_summ <- aggregate(final_data, by=list(subject_no=final_data$subjects, activity=final_data$labels_desc), FUN=mean, na.rm=TRUE)
drop <- names(final_summ) %in% c("labels", "labels_desc", "subjects", "name")
final_summ <- final_summ[,!drop]

final_summ <- final_summ[order(final_summ$subject_no, final_summ$activity),]

write.table(final_summ,"final_summ.txt", sep="\t", row.names=FALSE)
