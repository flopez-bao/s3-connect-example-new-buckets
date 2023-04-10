rm(list = ls())
library(aws.s3)
library(readxl)
library(paws)
library(jsonlite)
library(readxl)
library(magrittr)
library(purrr)

# connect ---------------------------------------

#Set the profile and region here
Sys.setenv(SECRET_NAME = Sys.getenv("SECRET_NAME"),
           AWS_DEFAULT_REGION = "us-east-1",
           AWS_REGION = "us-east-1")

svc <- secretsmanager()

#Put the name of the secret which contains the aws key info
see <- svc$get_secret_value(
  SecretId = Sys.getenv("SECRET_NAME")
)

see <- fromJSON(see$SecretString)

#Fill in the strings
Sys.setenv(AWS_ACCESS_KEY_ID = see$aws_access_key,
           AWS_SECRET_ACCESS_KEY = see$aws_secret_access_key,
           #AWS_PROFILE = Sys.getenv("AWS_PROFILE"),
           AWS_DEFAULT_REGION = "us-east-1",
           AWS_REGION = "us-east-1")

#Delete the secret info as its now an env variable
rm(see)
rm(svc)

# read from the main read bucket -----------------------------------------------
my_bucket <- Sys.getenv("TEST_BUCKET")

# Lists all of bucket contents, fill in your bucket
choices <- aws.s3::get_bucket(bucket = my_bucket)

# get just path names
choices <- lapply(choices, "[[", 1)

# get just file names
cleaned_choices <- lapply(choices, function(x) gsub(".*\\/", "", x))

# make dataframe of file names and path names
choices <- do.call(rbind, Map(data.frame, file_names = cleaned_choices,
                              path_names = choices, stringsAsFactors = FALSE))

# pull all tags
s3_source <- paws::s3()

all_tags <- 
  choices$path_names %>%
  lapply(function(key) {
    
    tag_set <- s3_source$get_object_tagging(
      Bucket = Sys.getenv("TEST_BUCKET"),
      Key = key
    )
    
    Key <- key
    tag_set
    
   })

# pull a specific tag in this case narrative parquet
s3_source$get_object_tagging(
  Bucket = Sys.getenv("TEST_BUCKET"),
  Key = choices$path_names[grep("Narratives.parquet", choices$path_names)]
)

# 
# 
# 
# 
# # data frame
# all_tags <- 
#   choices$path_names %>%
#   lapply(function(key) {
#     
#     tag_set <- s3_source$get_object_tagging(
#       Bucket = Sys.getenv("TEST_BUCKET"),
#       Key = key
#     )
#     
#     Key <- key
#     VersionId <- tag_set$VersionId
#     
#     if(length(tag_set$TagSet) < 1) {
#       TagKey <- NA
#       TagValue <- NA
#     } else {
#       TagKey <- tag_set$TagSet[[1]]$Key
#       TagValue <- tag_set$TagSet[[1]]$Value
#     }
# 
#     # make dataframe
#     data.frame(
#       Key,
#       VersionId,
#       TagKey,
#       TagValue
#     )
# 
# })
# 
# all_tags_df <- do.call(rbind, all_tags)
# 
