
##Final Analysis Assingment##


cat("\014")  # Clear Console
rm(list = ls(all.names = TRUE))# clear all
gc()
set.seed(42) # Set a seed to ensure repeatable random samples 

library(data.table)
library(ggplot2)  



analysis_data <- fread("/Users/chase/Documents/CaseAnalysis.csv" , header = TRUE) 
names(analysis_data) 
head(analysis_data)
str(analysis_data) 

analysis_data[, signup_ts := as.POSIXct(signup_ts, format = "%m/%d/%Y %H:%M")]
analysis_data[, conv_1 := as.POSIXct(conv_1, format = "%m/%d/%Y %H:%M")] 
analysis_data[, conv_2 := as.POSIXct(conv_2, format = "%m/%d/%Y %H:%M")]

str(analysis_data) 


#Question 1 - how many unique users signed up? 

unique_users <- analysis_data[, .(unique_users = uniqueN(user_id))] 
unique_users #350 unique users signed up 

#Question 2 - what do we need to do to make the data analysis ready? 

#drop the duplicates in the user_id column (and maybe the signup_ts column)  

analysis_data <- unique(analysis_data, by = c("user_id", "signup_ts"))

#Question 3 - Considering users who left reviews, how many unique values are there in the product_review column?  

unique_reviews <- analysis_data[!is.na(product_review), .(unique_reviews = uniqueN(product_review))]
unique_reviews # 9 unique reviews
 

#Question 4 - What percentage of users hit the landing page? 

total_signed_up <- uniqueN(analysis_data[!is.na(user_id), user_id])
total_visited_landing_page <- sum(analysis_data[!is.na(conv_1) & conv_1 != 0, .N])
percentage_visited_landing_page <- total_visited_landing_page / total_signed_up
formatted_percentage <- formatC(percentage_visited_landing_page * 100, format = "f", digits = 2)
cat("Percentage of users who hit the landing page:", formatted_percentage, "%\n") #50.57%

#Question 5 - Conversion rate from landing page to purchase

# Subset data to users who hit the landing page
users_hit_landing_page <- analysis_data[!is.na(conv_1)]
users_purchased_from_landing_page <- users_hit_landing_page[!is.na(conv_2)]
percentage_purchased_from_landing_page <- (nrow(users_purchased_from_landing_page) 
                                           / nrow(users_hit_landing_page)) * 100
formatted_percentage_purchased_from_landing_page <- formatC(percentage_purchased_from_landing_page, 
                                                            format = "f", digits = 2)
cat("Percentage of users who hit the landing page and went on to purchase the product: ", 
    formatted_percentage_purchased_from_landing_page, sep="") # 51.41%

#Question 6 - what region saw the most purchases 

most_purchases_by_region <- analysis_data[!is.na(conv_2), .(most_purchases_by_region = .N), by = region] 
most_purchases_by_region #Region 1 saw the most purchases


#Question 7  - what is the average time between signup and purchase

valid_data <- analysis_data[!is.na(signup_ts) & !is.na(conv_2)]
valid_data[, time_to_purchase := as.numeric(difftime(conv_2, signup_ts, units = "days"))]
average_time_to_purchase <- mean(valid_data$time_to_purchase)
print(average_time_to_purchase) 

#average time is 108.43 days 






