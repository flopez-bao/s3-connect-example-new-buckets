rm(list = ls())
library(aws.s3)
library(readxl)
library(paws)
library(jsonlite)
library(readxl)

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

# filter just files that end in txt or xlsx or csv
choices <- choices[grepl("txt$|xlsx$|csv$|xlsx$", choices$file_names), ]
print(choices)
# reset row names
rownames(choices) <- NULL

# grabbing meta data ----

#grab all detail and summary files with path and view them
choices_meta <- choices[grepl("detailed|summary", choices$file_names),]

# lets say i want information on ou historic, i can pull the two metadata files
# for that directory
my_data <- "MER_Structured_Datasets/Current_Frozen/OU_Historic/detailed_metadata.csv"
data <- aws.s3::s3read_using(FUN = readr::read_delim, "|", escape_double = FALSE,
                             trim_ws = TRUE, col_types = readr::cols(.default = readr::col_character()
                             ), 
                             bucket = my_bucket,
                             object = my_data)

data

# here is the summary data
my_data <- "MER_Structured_Datasets/Current_Frozen/OU_Historic/summary_metadata.csv"
data <- aws.s3::s3read_using(FUN = readr::read_delim, "|", escape_double = FALSE,
                             trim_ws = TRUE, col_types = readr::cols(.default = readr::col_character()
                             ), 
                             bucket = my_bucket,
                             object = my_data)

data
