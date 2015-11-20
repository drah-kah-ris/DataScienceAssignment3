#Transforming the training data. Features are used the Column names
#Columns other than mean() and std() columns are dropped
train_data <- read.table("./train/X_train.txt") 
train_data_names <- read.table("features.txt",sep = " ") 
train_data_names <- c(as.character(train_data_names$V2)) 
names(train_data) <- train_data_names
mean_cols <- grep(".*\\mean()\\(.*)",colnames(train_data)) 
std_cols <- grep("std",colnames(train_data))
train_data_desired <- train_data[,c(mean_cols,std_cols)]

#Mapping the activity with the training activity file
activity <- read.table("./train/y_train.txt")
activity_labels <- read.table("activity_labels.txt")
names(activity) <- c("id")
names(activity_labels) <- c("id","activity")
activity_joined <- join(activity,activity_joined,by = "id")
train_data_desired["activity"] <- activity_joined["activity"]

#Concatenating the training subject file
train_data_desired["subject"] <- read.table("./train/subject_train.txt")

#Transforming the test data same as training data
test_data <- read.table("./test/X_test.txt")
names(test_data) <- train_data_names
test_data_desired <- test_data[,c(mean_cols,std_cols)]

#Mapping the activity with the test activity file
activity <- read.table("./test/y_test.txt")
names(activity) <- c("id")
activity_joined <- join(activity,activity_joined,by = "id")
test_data_desired["activity"] <- activity_joined["activity"]

#Concatenating the test subject file
test_data_desired["subject"] <- read.table("./test/subject_test.txt")

#Merging test and training data and creating the average of each variable for each activity and each subject
merged_data <- rbind(train_data_desired,test_data_desired)
grouped_data <- group_by(merged_data,subject,activity)
grouped_mean_data <- summarize_each(grouped_data,funs(mean))

write.table(grouped_mean_data,file = "Subject_Activity_Average.txt",row.name=FALSE)


