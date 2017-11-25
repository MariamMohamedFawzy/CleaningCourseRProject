base_path = '/Users/apple/Downloads/UCI HAR Dataset/'
X_train = read.table(paste(base_path, 'train/X_train.txt', sep=''))
y_train = read.table(paste(base_path, 'train/y_train.txt', sep=''))

X_test = read.table(paste(base_path, 'test/X_test.txt', sep=''))
y_test = read.table(paste(base_path, 'test/y_test.txt', sep=''))


all_x = rbind(X_train, X_test)
all_y = rbind(y_train, y_test)

features = read.table(paste(base_path, 'features.txt', sep=''))
features_selected = features[grepl("mean()", features$V2, fixed = TRUE) | grepl("std()", features$V2, fixed = TRUE),]

selected_x = all_x[, features_selected$V1]

names_of_cols = as.list(as.character(features_selected$V2))

names(selected_x) <- names_of_cols

activity_labels = read.table(paste(base_path, 'activity_labels.txt', sep=''))

subject_train = read.table(paste(base_path, 'train/subject_train.txt', sep=''))
subject_test= read.table(paste(base_path, 'test/subject_test.txt', sep=''))

all_subject = rbind(subject_train, subject_test)

selected_x$subject = all_subject$V1
selected_x$activity = all_y$V1

cols_x = names(selected_x)[1:(length(names(selected_x))-2)]

a = selected_x[c("subject", "activity")]
a2 = paste0(a$subject, a$activity, sep = "")

col_x = cols_x[1]

vals = tapply(as.list(selected_x[col_x])[[1]], a2, mean)
df_new = data.frame(vals)

for (i in 2:length(cols_x)){
  col_x = cols_x[i]
  vals = tapply(as.list(selected_x[col_x])[[1]], a2, mean)
  df_new[col_x] = vals
}

names(df_new) <- cols_x
  
df_new$activity = sapply(unique(a2), function(x){as.integer(substr(x, nchar(x), nchar(x)))})
df_new$subject = sapply(unique(a2), function(x){as.integer(substr(x, 1, nchar(x)-1))})

df2_new = merge(df_new, activity_labels, by.x = 'activity', by.y = 'V1')
names(df2_new)[69] <- "activity"

write.table(df2_new, file = paste(base_path, "result.txt"), row.names = FALSE)


# d = sapply(names_of_cols, strsplit, split="-")
# f <- function(line) { return(line[1]) }
# d2 = sapply(d, f)
# d2 <- unique(d2)


