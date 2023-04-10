library(aws.s3)
library(readxl)
library(paws)


# depending on your specific prefix you will change
# your prefix is basically the folder in S3 you are allowed to write to
# in your workspace``
s3_write <- function(bucket, your_prefix) {
    my_prefix = "/system_myapp/"
    s3write_using(mtcars, FUN = write.csv,
                  bucket = bucket,
                  object = paste0(my_prefix, "my_file_name.csv")
    )

}



