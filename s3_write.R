library(aws.s3)
library(readxl)
library(paws)


s3_write <- function(server) {
  
  #my bucket
  my_bucket <- paste(server,".pepfar.data.data-extracts",sep="")
  
  # my data frame
  my_df <- data.frame("year" = c(2019,2020,2021), "indicator" = c(1,2,3))
  
  print("writing the following to s3...")
  print(my_df)
  
  # write to S3
  response <- 
  tryCatch({
   
      s3write_using(my_df, FUN = write.csv,
                  bucket = paste(server,".pepfar.data.my-data-group",sep=""),
                  object = "byod_covid_mer/file_share/test.csv")
  
  },
    error=function(e) {
      return(capture.output(e))
  })
  
  # if no error return success message
  return(response)
  
}



