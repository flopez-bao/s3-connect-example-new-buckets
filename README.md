# README

An example of a BAO Rstudio/Posit Connect community application. Use this
as a template framework for creating your basic application. As of 4/10/23
oauth is not integrated into this example.

## Installation
- clone this repo
- make sure you have `renv` installed, if not run `install.packages('renv')`
- run `renv::activate()`
- open the newly created `.Rprofile` in your root directory and set up your env variables,
reference `example_Rprofile_or_Global.R` to see what your `.Rprofile` should look like.
- open .gitignore and add `.Rprofile` to the list
- restart your r session
- run `renv::restore()` to restore your environment -- this essentially makes sure your environment
reflects what is in the `renv.lock file` in this repo
- you should now be able to run the application and/or the scripts

## Usage

Reference the `server` and `ui` files for a basic app example with code for
logging in and out and reading from s3 as well as hashed out examples for writing/reading
to your s3 workspace. 

For a scripted example of connecting to S3 reference `manual_scripts/manual_connect_w_secret.R`.

## Important

In order to run the application and connect to S3 you must set up environment variables. 
Reference `example_Rprofile_or_Global.R` to see what your `.Rprofile` should look like.