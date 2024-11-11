# Data Handling / Data Wrangling

#----------------------------
# A working example
#----------------------------
# Research Questions: How men and women differ in the ways they lead their 
# organizations. Typical questions might be

# Do men and women in management positions differ in the degree to which
# they defer to superiors?
# Does this vary from country to country, or are these gender differences 
# universal?

# Creating the data frame
#-----------------------------------------
leadership <- data.frame(
  manager = c(1, 2, 3, 4, 5),
  date    = c("10/24/08", "10/28/08", "10/1/08", "10/12/08", "5/1/09"),
  country = c("US", "US", "UK", "UK", "UK"),
  gender  = c("M", "F", "F", "M", "F"),
  age     = c(32, 45, 25, 39, 99),
  q1      = c(5, 3, 3, 3, 2),
  q2      = c(4, 5, 5, 3, 2),
  q3      = c(5, 2, 5, 4, 1),
  q4      = c(5, 5, 5, NA, 2),
  q5      = c(5, 5, 2, NA, 1)
)
head(leadership)
View(leadership)

#-------------------------------------
# Creating new variables
#-------------------------------------
leadership <- transform(leadership,
                        total_score  =  q1 + q2 + q3 + q4 + q5,
                        mean_score = (q1 + q2 + q3 + q4 + q5)/5)
head(leadership)

#-----------------------------------
# Recoding variables
#-----------------------------------
# Let’s say you want to recode the ages of the managers in the leadership 
# dataset from the continuous variable age to the categorical variable agecat 
# (Young, Middle Aged, Elder). 

# First, you must recode the value 99 for age to indicate that the value is 
# missing using  code such as

leadership$age[leadership$age == 99] <- NA
head(leadership)

# Use the following code to create the agecat variable:
leadership$agecat[leadership$age > 75] <- "Elder"
leadership$agecat[leadership$age >= 55 & leadership$age <= 75] <- "Middle Aged"
leadership$agecat[leadership$age < 55] <- "Young"

head(leadership)


#-----------------------------------
# Renaming variables
#-----------------------------------
# If you’re not happy with your variable names, you can change them 
# interactively or # programmatically. 

names(leadership)[2] <- "testDate"
head(leadership)

# To check the col names of your dataframe
names(leadership)

names(leadership)[6:10] <- c("item1", "item2", "item3", "item4", "item5")

head(leadership)

#-----------------------------------
# Missing variables
#-----------------------------------
# The function is.na() allows you to test for the presence of missing values.
# Assume that you have this vector:
y <- c(1, 2, 3, NA)
is.na(y)

is.na(leadership[,6:10])

# R doesn’t represent infinite or impossible values as missing values.
# Impossible values (for example, sin(Inf)) are represented by the symbol 
# NaN (not a number). To identify these values, you need to use is 
# .infinite() or is.nan().

# Recoding values to missing
#-----------------------------------
leadership$age[leadership$age == 99] <- NA

head(leadership)

# Excluding missing values from analyses
x <- c(1, 2, NA, 3)
y <- x[1] + x[2] + x[3] + x[4]
z <- sum(x)
(z <- sum(x, na.rm = TRUE))

# You can remove any observation with missing data by using the na.omit() 
# function, which deletes any rows with missing data. Let’s apply this to 
# the leadership dataset in the following listing.
newdata <- na.omit(leadership)
newdata

#-----------------------------------
# Date values
#-----------------------------------
# Dates are typically entered into R as character strings and then translated 
# into date variables that are stored numerically. 

# The function as.Date() is used to make this translation.

# The syntax is as.Date(x, "input_format"), where x is the character data
# and input_format gives the appropriate format for reading the date

# The default format for inputting dates is yyyy-mm-dd. The statement
mydates <- as.Date(c("2007-06-22", "2004-02-13"))

mydates
# In contrast,

strDates <- c("01/05/1965", "08/16/1975")
dates <- as.Date(strDates, "%m/%d/%Y")
dates
# reads the data using a mm/dd/yyyy format.

# In the leadership dataset, date is coded as a character variable in 
# mm/dd/yy format.
# Therefore

str(leadership)

myformat <- "%m/%d/%y"
leadership$date <- as.Date(leadership$testDate, format = myformat)
head(leadership)
str(leadership)

# Sys.Date() returns today’s date, and date() returns the current date and time.
Sys.Date()
date()


# You can use the format(x, format="output_format") function to output dates 
# in a specified format and to extract portions of dates:
today <- Sys.Date()
format(today, format="%B %d %Y")  
format(today, format="%A")        

startdate <- as.Date("2020-02-13")
enddate <- as.Date("2021-01-22")
days <- enddate - startdate
days

# Finally, you can also use the function difftime() to calculate a time 
# interval and express it as seconds, minutes, hours, days, or weeks. 

# Let’s assume that I was born on July 23, 1977. How old am I?:
today <- Sys.Date()
dob <- as.Date("1977-07-23")
difftime(today, dob, units="weeks")

day_of_week <- weekdays(dob)
day_of_week


#------------------------------------------
# 3.7 Type conversions
#------------------------------------------
# Functions of the form is.datatype() return TRUE or FALSE, whereas as.datatype() converts 
# the argument to that type.

# Table 3.5 Type-conversion functions
# Test                    Convert
#---------------------------------------
# is.numeric()            as.numeric()
# is.character()          as.character()
# is.vector()             as.vector()
# is.matrix()             as.matrix()
# is.data.frame()         as.data.frame()
# is.factor()             as.factor()
# is.logical()            as.logical()

a <- c(1,2,3)
a

is.numeric(a)

is.vector(a)

a <- as.character(a)
a

is.numeric(a)

is.vector(a)

is.character(a)

#-------------------------------------
# Sorting data
#-------------------------------------
# Sometimes, viewing a dataset in a sorted order can tell you quite a bit 
# about the data.

# For example, which managers are most deferential? To sort a data frame in R, 
# you use the order() function. By default, the sorting order is ascending. 

# Prepend the sorting variable with a minus sign to indicate descending order. 

# The following examples illustrate sorting with the leadership data frame.

# The following statement creates a new dataset containing rows sorted from 
# youngest manager to oldest manager.
newdata <- leadership[order(leadership$age),]  
newdata

# The statement below sorts the rows into female followed by male and youngest 
# to oldest within each gender. 
newdata <- leadership[order(leadership$gender, leadership$age),]
newdata

# The statement below sorts the rows by gender, and then from oldest to 
# youngest manager within each gender.
newdata <-leadership[order(leadership$gender, -leadership$age),]
newdata

# The END
