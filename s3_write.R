library(aws.s3)
library(readxl)
library(paws)


s3_write <- function(bucket) {
  
  #my bucket
  my_bucket <- paste(bucket)
  
  # my data frame
  my_df <- data.frame("year" = c(2019,2020,2021), "indicator" = c(1,2,3))
  
  print(paste0("writing the following to this s3 bucket...",my_bucket))
  print(my_df)
  
  # write to S3
  response <- 
  tryCatch({
   
      s3write_using(my_df, FUN = write.csv,
                  bucket = my_bucket,
                  object = "se1325_system_covid_mer/testing_fl.csv")
  
  },
    error=function(e) {
      return(capture.output(e))
  })
  
  # if no error return success message
  return(response)
  
}



