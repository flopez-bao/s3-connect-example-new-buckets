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

# read narratives data 
  my_data <- "Narratives/Current_Frozen/xlsx/Narratives.xlsx"
  data <- aws.s3::s3read_using(FUN = readxl::read_xlsx,
                               trim_ws = TRUE, 
                               bucket = my_bucket,
                               object = my_data)
  
  head(data, 5)
  

  # read mer structured data
  # read options
  #read in data, fill in your bucket name and file name (object should hold the name of the file you want to read)
  my_data <- "MER_Structured_Datasets/Current_Frozen/PSNU_Recent/txt/MER_Structured_Datasets_PSNU_IM_Recent_Ukraine.txt"
  data <- aws.s3::s3read_using(FUN = readr::read_delim, "|", escape_double = FALSE,
                               trim_ws = TRUE, col_types = readr::cols(.default = readr::col_character()
                               ), 
                               bucket = my_bucket,
                               object = my_data)
  
  head(data, 5)
  

# test writing --------------

# write to narratives workspace

  print("writing to narratives...")
  s3write_using(mtcars, FUN = write.csv,
                bucket = Sys.getenv("TEST_BUCKET_WRITE"),
                object = "system_narratives/testing_fl.csv")
  
  # write to yoda workspace
  
  print("writing to yoda...")
  s3write_using(mtcars, FUN = write.csv,
               bucket = Sys.getenv("TEST_BUCKET_WRITE"),
               object = "system_yoda/testing_fl.csv"
  )
  
  # write to dreams workspace
  
  print("writing to system dreams...")
  s3write_using(mtcars, FUN = write.csv,
                bucket = Sys.getenv("TEST_BUCKET_WRITE"),
                object = "system_dreams_saturation/testing_fl.csv"
  )
  

# test reading from write bucket --------


  # write to narratives workspace
  
  print("reading narratives data...")
  s3read_using(FUN = read.csv,
                bucket = Sys.getenv("TEST_BUCKET_WRITE"),
                object = "system_narratives/testing_fl.csv"
  )
  
  # write to yoda workspace
  
  print("reading yoda data...")
  s3read_using(FUN = read.csv,
                bucket = Sys.getenv("TEST_BUCKET_WRITE"),
                object = "system_yoda/testing_fl.csv"
  )
  
  # write to dreams workspace
  
  print("reading dreams data...")
  s3read_using(FUN = read.csv,
               bucket = Sys.getenv("TEST_BUCKET_WRITE"),
               object = "system_dreams_saturation/testing_fl.csv"
  )
  

