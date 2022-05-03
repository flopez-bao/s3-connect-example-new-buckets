library(aws.s3)
library(readxl)
library(paws)


s3_write <- function(bucket) {
  
  if (Sys.getenv("SECRET_ID") == "system_narratives") {
    
    print("writing to narratives...")
    s3write_using(mtcars, FUN = write.csv,
                  bucket = bucket,
                  object = "system_narratives/testing_fl.csv")
    
  } else {
    
    print("writing to yoda...")
    s3write_using(mtcars, FUN = write.csv,
                  bucket = bucket,
                  object = "system_yoda/testing_fl.csv"
    )
    
  }
}



