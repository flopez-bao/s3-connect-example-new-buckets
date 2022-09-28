# the following aws profile configuration can only access testing.
source("renv/activate.R")

# user credentials ----
Sys.setenv(BASE_URL = "****")
Sys.setenv(SECRET_NAME = "****")

# buckets ----
Sys.setenv(TEST_BUCKET = "*****")
Sys.setenv(TEST_BUCKET_WRITE = "***")
