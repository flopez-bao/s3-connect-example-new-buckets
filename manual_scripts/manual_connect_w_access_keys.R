# testing connection ----------------------------------------------------------
rm(list = ls())
library(aws.s3)
library(paws)

# IMPORTANT****************
# R WANTS AWS_ACCESS_KEY_ID SET because CRUD functions for package aws.s3
# want to reference that environment variable as opposed to AWS_ACCESS_KEY
Sys.setenv(
  AWS_S3_BUCKET = "enter bucket here",
  AWS_REGION = "us-east-1",
  AWS_ACCESS_KEY_ID = Sys.getenv("AWS_ACCESS_KEY")
)

Sys.getenv("AWS_SECRET_ACCESS_KEY")
Sys.getenv("AWS_ACCESS_KEY")
Sys.getenv("AWS_ACCESS_KEY_ID")
Sys.getenv("AWS_S3_BUCKET")
Sys.getenv("AWS_REGION")
my_bucket <- Sys.getenv("AWS_S3_BUCKET")

# Lists all of bucket contents in bao ----
my_prefix = "bao/"
choices <- aws.s3::get_bucket(
  bucket = my_bucket,
  key = Sys.getenv("AWS_ACCESS_KEY"),
  secret = Sys.getenv("AWS_SECRET_ACCESS_KEY"),
  prefix = my_prefix,
)

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

# read a test file from bao
s3read_using(FUN = read.csv,
             bucket = my_bucket,
             object = paste0(my_prefix, "testfile.txt")
)


# write a test file to bao
s3write_using(mtcars, FUN = write.csv,
              bucket = my_bucket,
              object = paste0(my_prefix, "testfile_fausto1.csv")
)

# delete a file 
delete_object(
  object = paste0(my_prefix, "testfile_fausto1.csv"),
  bucket = my_bucket
)

# test pet connection and list ------------------------------------------------
rm(choices, cleaned_choices, my_prefix)

my_prefix <- "pet/"

choices <- aws.s3::get_bucket(
  bucket = my_bucket,
  key = Sys.getenv("AWS_ACCESS_KEY"),
  secret = Sys.getenv("AWS_SECRET_ACCESS_KEY"),
  prefix = my_prefix,
)


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

# read, write, delete ----

# read a file
s3read_using(FUN = read.csv,
             bucket = my_bucket,
             object = paste0(my_prefix, "testfile.txt")
)


# write a test file
s3write_using(mtcars, FUN = write.csv,
              bucket = my_bucket,
              object = paste0(my_prefix, "testfile_fausto1.csv")
)

# delete a file 
delete_object(
  object = paste0(my_prefix, "testfile_fausto1.csv"),
  bucket = my_bucket
)

rm(list =ls())  



