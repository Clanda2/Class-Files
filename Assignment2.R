
# BUS 462 -- Assignment 2 
# Chase Landa 
# I pledge on my honor that I have neither received nor given unauthorized assistance on this deliverable. 

######################################################### 

#loading the data and packages

chimera_data <- read.csv("/Users/chase/Documents/ChimeraData_A2.csv" , header = TRUE) 
names(chimera_data) 
library(ggplot2) 

######################################################### 

#Part 1: Preliminary Analysis 

#Question 1 

  #Gender Ratio
gender_table <- table(chimera_data$gender)
gender_ratio <- prop.table(gender_table) * 100  
print(gender_ratio)

gender_df <- as.data.frame(gender_ratio)
names(gender_df)  <- c("Gender", "Percentage")
gender_df$Gender <- factor(gender_df$Gender, levels = c("0", "1"), 
                           labels = c("Male", "Female")) 

ggplot(gender_df, aes(x = Gender, y = Percentage, fill = Gender)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_fill_manual(values = c("Male" = "blue", "Female" = "pink")) +
  labs(title = "Gender Ratio at Chimera", x = "Gender", y = "Percentage") +
  theme_minimal()

#mean,median and mode of employee age
mean(chimera_data$age)
median(chimera_data$age)
sd(chimera_data$age)

#show the age distribution of employees  
age_bins <- cut(chimera_data$age, breaks = seq(0, 100, by = 10), right = FALSE)
age_distribution <- table(age_bins)
age_percentage <- prop.table(age_distribution) * 100 
print(age_percentage)  



age_df <- as.data.frame(age_distribution)
names(age_df) <- c("AgeRange", "Count")

ggplot(age_df, aes(x = AgeRange, y = Count)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(title = "Age Distribution of Employees", x = "Age Range",
       y = "Number of Employees")


#Number of Cities 
number_of_cities <- length(unique(chimera_data$city_size)) 
print(number_of_cities) 

#non top-tier school 
non_top_tier <- chimera_data[chimera_data$education %in% c(2,3), ] 
percentage_non_top_tier <- nrow(non_top_tier) / nrow(chimera_data) * 100  
print(percentage_non_top_tier)  


#Question 2  
  #Distribution of employee job satisfaction  

mean(chimera_data$job_satisfaction)
sd(chimera_data$job_satisfaction)
hist(chimera_data$job_satisfaction, col = "lightblue", main = "Job Satisfaction Distribution", 
     xlab = "Job Satisfaction")

mean(chimera_data$kpi_performance) 
sd(chimera_data$kpi_performance) 
hist(chimera_data$kpi_performance, col = "lightblue", main = "Employee Performance Distribution", 
     xlab = "Employee Evaluation") 

mean(chimera_data$boss_survey) 
sd(chimera_data$boss_survey) 
hist(chimera_data$boss_survey, col = "lightblue", main = "Manager Evaluation Distribution", 
     xlab = "Manager Evaluation")

mean(chimera_data$years_since_promotion) 
sd(chimera_data$years_since_promotion) 
hist(chimera_data$years_since_promotion, col = "lightblue", main = "Years Since Promotion Distribution", 
     xlab = "Years Since Promotion")

mean(chimera_data$salary) 
sd(chimera_data$salary) 
hist(chimera_data$salary, col = "lightblue", main = "Salary Distribution", 
     xlab = "Salary")

#Question 3  
 
#All employees at the beginning of the year 

library(stargazer)  
stargazer(chimera_data, type = "text") 
summary(chimera_data) 
boxplot(chimera_data$age, main = "Age Distribution of Employees", ylab = "Age") 

#Employees exiting the firm by the end of the year 
exiting_employees <- chimera_data[chimera_data$exit == 1, ] 
stargazer(exiting_employees, type = "text") 
summary(exiting_employees) 
boxplot(exiting_employees$age, main = "Age Distribution of Exiting Employees", ylab = "Age") 

#Employees who remained with the firm by the end of the year 
remaining_employees <- chimera_data[chimera_data$exit == 0, ] 
stargazer(remaining_employees, type = "text") 
summary(remaining_employees) 
boxplot(remaining_employees$age, main = "Age Distribution of Remaining Employees", ylab = "Age")  

#Question 4  
#The employees who exited the firm had a lower mean age, lower mean job satisfaction, 
#lower mean KPI performance, lower mean boss survey, lower mean years since promotion, and lower mean salary. 


#Part 2: Preliminary Regressions 

#Question 5

#Model A
model_a <- lm(exit ~ salary + rank + gender, data = chimera_data) 
summary(model_a)
stargazer(model_a, type = "text") 
plot (model_a)

#Model B 
model_b <- lm(exit ~ boss_survey + job_satisfaction, data = chimera_data) 
summary(model_b) 
stargazer(model_b, type = "text")  
plot (model_b)

#Model C 
model_c <- lm(exit ~ salary + boss_survey + job_satisfaction + rank + gender, data = chimera_data) 
summary(model_c) 
stargazer(model_c, type = "text") 


 
#Based off on adjusted R squared of the models, Model C (Adjust R^2 = 0.163) is the best model 

#### Model Diagnostics ##### --> Need to ask for clarity here 










