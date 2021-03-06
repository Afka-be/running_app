library(shiny)
library(shinyWidgets)
#library(shinydashboard)
library(shiny.semantic)
library(semantic.dashboard)
library(rsconnect)
library(robservable)
library(tidyverse) #Needed for read_csv (not to be confused with read.csv)
library(readr)
library(readxl)
library(ggplot2)
library(data.table)
library(leaflet)
library(htmltools)
library(scales)
library(prompter)
library(dplyr)
library(ggmap)
library(Rcpp)
library(osrm)
library(shinyjs)
library(ECharts2Shiny)


#import the R files inside the R folder and process them
lapply(list.files("R"), FUN = function(x) source(paste0("R/", x)))


#Create a global list which welcomes parameters throughout the entire App
#This list is used for the rmarkdown report creation
#Stocks the values we need
#We can use them in running_generatedoc.r + report.rmd
run_params <<- list()
