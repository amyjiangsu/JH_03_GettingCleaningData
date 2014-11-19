library("data.table")
library("reshape2")

# Combining training and testing X data
test.X <- read.table("./UCI HAR Dataset/test/X_test.txt")
train.X <- read.table("./UCI HAR Dataset/train/X_train.txt")
data.X  <- rbind(test.X, train.X)

# Adding features as column names
label.features <- read.table("./UCI HAR Dataset/features.txt")[,2]
names(data.X) = label.features

# Select the measurements on the mean and standard deviation.
label.features.select <- grepl("mean|std", label.features)

# Extract only the measurements on the mean and standard deviation.
data.X = data.X[,label.features.select]

# Combining training and testing y data
test.y <- read.table("./UCI HAR Dataset/test/y_test.txt")
train.y <- read.table("./UCI HAR Dataset/train/y_train.txt")
data.y  <- rbind(test.y, train.y)

# Adding activity ID lable, Activity Desc column to data.y
label.activity <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
data.y[,2]  <- label.activity[data.y[,1]]
data.y[,1]  <- NULL
names(data.y) = "Activity_Desc"

# Combining training and testing subject data
test.subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
train.subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
data.subject  <- rbind(test.subject, train.subject)
names(data.subject)  <- "Subject"

# Combining data.X, data.y, data.subject
data.all  <- cbind(data.subject, data.y, data.X)

# Melting the table in order to get all mean and std measurement by subject, activity, and feature
label.id   = c("Subject", "Activity_Desc")
label.data = setdiff(colnames(data.all), label.id)
data.melt  = melt(data.all, id = label.id, measure.vars = label.data)

# Decast the table using mean function, applying to subject and activity
data.tidy  = dcast(data.melt, Subject + 'Activity_Desc' ~ variable, mean)

# Writing the result to tidy_data.txt file
write.table(data.tidy, file = "./tidy_data.txt")