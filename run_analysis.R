        library (dplyr)

        ## Step1: Downloading the data from the URL mentioned and unzipping data file into folder
                if(!file.exists("./WearData")){
                        dir.create("./WearData")
                }
                fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                download.file(fileUrl,destfile="./WearData/Dataset.zip",method="curl")
                unzip(zipfile="./data/Dataset.zip",exdir="./data")
                directory <- file.path("./WearData" , "UCI HAR Dataset")
        
        ## Step2: Read Features data, Subject Data and Activity Data from the downloaded data
                ## Read Features data
                path = paste (directory, "/test", sep = "")
                DT_X_test <- read.table (paste (path, "/X_test.txt", sep = ""))
                path = paste (directory, "/train", sep = "")
                DT_X_train <- read.table (paste (path, "/X_train.txt", sep = ""))
                
                ## Read Subject data
                path = paste (directory, "/test", sep = "")
                DT_Subject_test <- read.table (paste (path, "/subject_test.txt", sep = ""))
                path = paste (directory, "/train", sep = "")
                DT_Subject_train <- read.table (paste (path, "/subject_train.txt", sep = ""))
                
                ## Read activity data
                path = paste (directory, "/test", sep = "")
                DT_y_test <- read.table (paste (path, "/y_test.txt", sep = ""))
                path = paste (directory, "/train", sep = "")
                DT_y_train <- read.table (paste (path, "/y_train.txt", sep = ""))
                
        ## Setp3: Merging Data from Test and Train parts
                DT_Features <- rbind (DT_X_test, DT_X_train)
                DT_Subject <- rbind (DT_Subject_test, DT_Subject_train)    
                DT_Activity <- rbind (DT_y_test, DT_y_train)
                
        ## Step4: Assigning column names to the Merged Data. For this Feature Names are read
                ##Read Feature Names
                path = directory
                DT_Feature_Names <- read.table (paste (path, "/features.txt", sep = ""))
                
                ##assign column names to 
                colnames (DT_Features) <- DT_Feature_Names$V2
                
        ## Step5: Assigning Subject and Activity Columns to the Merged Data Set
                ##adding column nameas for subject and activity to DT_Feature_Names
                names (DT_Subject) <- "Subject"
                names (DT_Activity) <- "Activity"
                ##adding subject  columns to the data_set
                DT_Features <- cbind (DT_Subject, DT_Features)
                ##adding activity columns to the data_set
                DT_Features <- cbind (DT_Activity, DT_Features)
                
                
        ## Step6: Selecting only Mean and Std variables from the Merged Data as per project instructions
                ## excluding duplicated column names, as needed for select commands
                dups=which(duplicated(DT_Feature_Names$V2))
                DT_Select <- subset(DT_Features, select = -c(dups))
                                
                ##subssetting featurs data set to select 
                DT_Features_Mean_Std <- select (DT_Select, contains ("Activity"), contains ("Subject"), contains ("mean()"), contains ("std()"))  
                
        ## Step7: Applying descriptive Activity names to the observations
                ## reading activity Labels
                path = directory
                DT_Activity_Labels <- read.table (paste (path, "/activity_labels.txt", sep = ""))
                
                ## replacing activity column by activity names
                DT_Features_Mean_Std$Activity <- DT_Activity_Labels$V2 [DT_Features_Mean_Std$Activity]
                
        ## Step8: Assigning descriptive variables names instead of abbreviations
                ##Appropriately labels the data set with descriptive variable names
                names(DT_Features_Mean_Std) <- gsub("^t", "time", names(DT_Features_Mean_Std))
                names(DT_Features_Mean_Std) <- gsub("^f", "frequency", names(DT_Features_Mean_Std))
                names(DT_Features_Mean_Std) <- gsub("Acc", "Accelerometer", names(DT_Features_Mean_Std))
                names(DT_Features_Mean_Std) <- gsub("Gyro", "Gyroscope", names(DT_Features_Mean_Std))
                names(DT_Features_Mean_Std) <- gsub("BodyBody", "Body", names(DT_Features_Mean_Std))
                names(DT_Features_Mean_Std) <- gsub("Mag", "Magnitude", names(DT_Features_Mean_Std))
                
                
        ## Step09: Creating 2nd Tidy data with mean values per subject and activity
                DT_Tidy2 <-aggregate(. ~Subject + Activity, DT_Features_Mean_Std, mean)
                
        ## Step10: Copying tidy data created in above step for uploading to github for project submission
                write.table(DT_Tidy2, file = "tidydata.txt",row.name=FALSE)
