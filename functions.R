# temporary function ----

# sendEventToS3 <- function(#app_info=NULL, 
#                           event_type = event_type, user_input=user_input) {
#   
#   # if user input is missing then 
#    if (is.null(user_input)) {
#      stop("you have not provided logging information")
#    }
#   
#   # establish params
#   app_name <- Sys.getenv("SECRET_ID")
#   app_year <- substr(Sys.Date(),1,4)
#   uuid  = user_input$uuid
#   source_user = user_input$d2_session$username
#   s3 <- paws::s3()
#   tm <- as.POSIXlt(Sys.time(), "UTC")
#   ts_file <- strftime(tm, "%Y_%m_%d_%H_%M_%s")
#   
#   # name of object in s3
#   object_name <-
#     paste0("R/",
#            app_name,"/",
#            app_year,
#            "/",
#            ts_file, ".csv")
#   
#   # add payload info
#   event_info <- list(
#     event_type = event_type,
#     app = app_name,
#     year = app_year,
#     uuid = uuid,
#     user = digest(source_user, "md5", serialize = FALSE),
#     ts = strftime(tm, "%Y-%m-%dT%H:%M:%S%z")
#   )
#   
#   print(event_info)
#   
#   tmp <- tempfile()
#   write.table(
#     as.data.frame(event_info),
#     file = tmp,
#     quote = FALSE,
#     sep = "|",
#     row.names = FALSE,
#     na = "",
#     fileEncoding = "UTF-8"
#   )
#   
#   #print("done writing")
#   
#   # Load the file as a raw binary
#   read_file <- file(tmp, "rb")
#   raw_file <- readBin(read_file, "raw", n = file.size(tmp))
#   close(read_file)
#   print(raw_file)
#   
#   r <- tryCatch({
#     foo <- s3$put_object(Bucket = Sys.getenv("LOG_BUCKET"),
#                          Body = raw_file,
#                          Key = object_name,
#                          ContentType = "text/csv")
#     
#     # foo <- s3write_using(raw_file, FUN = write.csv,
#     #                      bucket = Sys.getenv("LOG_BUCKET"),
#     #                      object = object_name
#     #)
#   },
#   error = function(err) {
#     print(err)
#     futile.logger::flog.error("Event could not be saved to S3", name = "datapack")
#     FALSE
#   })
#   
#   unlink(tmp)
#   
#   return(r)
# }

