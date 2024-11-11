# Apply Functions
# Apply functions are a family of functions in base R which allow you to repetitively perform an action 
# on multiple chunks of data. An apply function is essentially a loop, but run faster than loops and 
# often require less code.

# The apply functions that we will address are apply, lapply, sapply, vapply, tapply, and mapply. 
# There are so many different apply functions because they are meant to operate on different types of data.

?apply

# apply function looks like this: apply(X, MARGIN, FUN).

# X is an array or matrix (this is the data that you will be performing the function on)
# Margin specifies whether you want to apply the function across rows (1) or columns (2)
# FUN is the function you want to use

# apply examples
# my.matrx is a matrix with 1-10 in column 1, 11-20 in column 2, and 21-30 in column 3. 
# my.matrx will be used to show some of the basic uses for the apply function.

my.matrx <- matrix(c(1:10, 11:20, 21:30), nrow = 10, ncol = 3)
my.matrx

# Using apply to find row sums
# What if I wanted to summarize the data in matrix m by finding the sum of each row? 
# The arguments are X = my.matrix, MARGIN = 1 (for row), and FUN = sum

apply(my.matrx, 1, sum)

# Using apply to find col sums
# What if I wanted to summarize the data in matrix m by finding the sum of each col? 
# The arguments are X = my.matrix, MARGIN = 2 (for row), and FUN = sum

apply(my.matrx, 2, sum)

# Creating a function in the arguments
# What if I wanted to be able to find how many data points (n) are in each column of m? 
# I can use the length function to do this. Because we are using columns, MARGIN = 2.

apply(my.matrx, 2, length)

# What if instead, I wanted to find n-1 for each column? 
# There isn’t a function in R to do this automatically, so I can create my own function. 
# If the function is simple, you can create it right inside the arguments for apply. 
# In the arguments I created a function that returns length - 1.

apply(my.matrx, 2, function (x) length(x)-1)

# Using a function defined outside of apply
# If you don’t want to write a function inside of the arguments, you can define the function 
# outside of apply, and then use that function in apply later. 

# This may be useful if you want to have the function available to use later. 
# In this example, a function to find standard error was created, then passed into an apply function.

st.err <- function(x){
  sd(x)/sqrt(length(x))
}
apply(my.matrx,2, st.err)

# Transforming data
# In the previous examples, apply was used to summarize over a row or column. 
# It can also be used to repeat a function on cells within a matrix. 
# In this example, the apply function is used to transform the values in each cell. 
# Pay attention to the MARGIN argument. 
# If you set the MARGIN to 1:2 it will have the function operate on each cell.
my.matrx
my.matrx2 <- apply(my.matrx,1:2, function(x) x+3)
my.matrx2

# apply function - with vectors
# The previous examples showed several ways to use the apply function on a matrix. 
# But what if I wanted to loop through a vector instead? 
# Will the apply function work?
vec <- c(1:10)
vec
apply(vec, 1, sum)

# If you run this function it will return the error: 
# Error in apply(v, 1, sum) : dim(X) must have a positive length. 
# As you can see, this didn’t work because apply was expecting the 
# data to have at least two dimensions. 
# If your data is a vector you need to use lapply, sapply, or vapply instead.

#----------------------------
# lapply, sapply, and vapply 
#----------------------------
# These are the functions that will loop a function through data in a list or vector. 
# First, try looking up lapply in the help section to see a description of all three function.

?lapply

# Here are the agruments for the three functions:
# lapply(X, FUN, …)
# sapply(X, FUN, …, simplify = TRUE, USE.NAMES = TRUE)
# vapply(X, FUN, FUN.VALUE, …, USE.NAMES = TRUE)

# In this case, X is a vector or list, and FUN is the function you want to use. 
# sapply and vapply have extra arguments, but most of them have default values, 
# so you don’t need to worry about them. 
# However, vapply requires another agrument called FUN.VALUE, which we will look at later.

#------------------------------
# Getting started with lapply
#-------------------------------
# Earlier, we created the vector v. 
# Let’s use that vector to test out the lapply function.

lapply(vec, sum)

# This function didn’t add up the values like we may have expected it to. 
# This is because lapply applies treats the vector like a list, and applies 
# the function to each point in the vector.

# Let’s try using a list instead

a <- c(1:9)
a

b <- c(1:12)
b

c <- c(1:15)
c

my.lst <- list(a,b,c)

lapply(my.lst, sum)

# This time, the lapply function seemed to work better. 
# The function summed each vector in the list and returned a list of the 3 sums.

#------------------------------
# Getting started with sapply
#-------------------------------
# sapply works just like lapply, but will simplify the output if possible. 
# This means that instead of returning a list like lapply, it will return a vector 
# instead if the data is simplifiable.

sapply(vec, sum)
# It will not work here on a vector; however, it will work like this:

sapply(my.lst, sum)
# Here a vector is returned as a final output. 

#------------------------------
# Getting started with vapply
#-------------------------------
# vapply is similar to sapply, but it requires you to specify what type of data you are expecting 
# the arguments for vapply are vapply(X, FUN, FUN.VALUE). 
# FUN.VALUE is where you specify the type of data you are expecting. 
# I am expecting each item in the list to return a single numeric value, so FUN.VALUE = numeric(1).

vapply(vec, sum, numeric(1))

vapply(my.lst, sum, numeric(1))

# If your function were to return more than one numeric value, FUN.VALUE = numeric(1) 
# will cause the function to return an error. 
# This could be useful if you are expecting only one result per subject.
# Here is the demonstration of error:
vapply(my.lst, function(x) x+2, numeric(1))

# Which function should I use, lapply, sapply, or vapply?
# If you are trying to decide which of these three functions to use, 
# because it is the simplest, I would suggest to use sapply if possible. 
# If you do not want your results to be simplified to a vector, lapply should be used. 
# If you want to specify the type of result you are expecting, use vapply.

#------------------------------
# tapply
#------------------------------

# Sometimes you may want to perform the apply function on some data, but have 
# it separated by factor. In that case, you should use tapply. 
# Let’s take a look at the information for tapply.

?tapply

# The arguments for tapply are tapply(X, INDEX, FUN). 
# The only new argument is INDEX, which is the factor you want to use to separate the data.

# tapply example 1: Means split by condition
#----------------------------------------------
# First, let’s create data with a factor for indexing. 
# Data set t will be created by adding a factor to matrix m and converting it to a dataframe.
my.matrx
tdata <- as.data.frame(cbind(c(1,1,1,1,1,2,2,2,2,2), my.matrx))
tdata
colnames(tdata)

# Now let’s use column 1 as the index and find the mean of column 2

tapply(tdata$V2, tdata$V1, mean)

# tapply example 2: Combining functions
#---------------------------------------
# You can use tapply to do some quick summary statistics on a variable split by condition. 
# In this example, I created a function that returns a vector of both the mean and standard deviation. 
# You can create a function like this for any apply function, not just tapply.

summary <- tapply(tdata$V2, tdata$V1, function(x) c(mean(x), sd(x)))
summary


#------------------------------
# mapply
#------------------------------

?mapply
# The arguments for mapply are mapply(FUN, …, MoreArgs = NULL, SIMPLIFY = TRUE, USE.NAMES = TRUE). 
# First you list the function, followed by the vectors you are using the rest of the arguments have 
# default values so they don’t need to be changed for now. 
# When you have a function that takes 2 arguments, the first vector goes into the first argument 
# and the second vector goes into the second argument.

# Example 1: Understanding mapply
#---------------------------------
# In this example, 1:9 is specifying the value to repeat, and 9:1 is specifying how many times to repeat.
# This order is based on the order of arguments in the rep function itself.

mapply(rep, 1:9, 9:1)

# Example 2: Creating a new variable
#-----------------------------------
# Another use for mapply would be to create a new variable. 
# For example, using dataset t, I could divide one column by another column to create a new value. 
# This would be useful for creating a ratio of two variables as shown in the example below.

tdata$V5 <- mapply(function(x, y) x/y, tdata$V2, tdata$V4)
tdata$V5
tdata

# Example 3: Saving data into a premade vector
#-----------------------------------------------
# When using an apply family function to create a new variable, one option is to create 
# a new vector ahead of time with the size of the vector pre-allocated. 
# I created a numeric vector of length 10 using the vector function. 
# The arguments for the vector function are vector(mode, length). 
# Inside mapply I created a function to multiple two variables together. 
# The results of the mapply function are then saved into the vector.

new.vec <- vector(mode = "numeric", length = 10)
new.vec
new.vec <- mapply(function(x, y) x*y, tdata$V3, tdata$V4)
new.vec

# Using apply functions on real datasets
#---------------------------------------
# This section will make use of the MASS package, which is a collection of publicly available datasets. 
# Please install MASS if you do not already have it. 
# If you do not have MASS installed, you can un comment the code below.

#install.packages("MASS")
library(MASS)

# Load the state data set. It contains information about all 50 states

data(state)

# Let’s look at the data we will be using. 
# We will be using the state.x77 dataset

head(state.x77)

# Structure of the dataset
str(state.x77)

# All the data in the dataset happens to be numeric, which is necessary when the function 
# inside the apply function requires numeric data.


# Example 1: Using apply to get summary data
#--------------------------------------------
# You can use apply to find measures of central tendency and dispersion

apply(state.x77, 2, mean)

# 2 means we are caluclating the values of mean for columns. 

apply(state.x77, 2, median)

apply(state.x77, 2, sd)


# Example 2: Saving the results of apply
#---------------------------------------
# In this, I created one function that gives the mean and SD, and another that give min, median, and max. 
# Then I saved them as objects that could be used later.

state.summary<- apply(state.x77, 2, function(x) c(mean(x), sd(x))) 
state.summary

state.range <- apply(state.x77, 2, function(x) c(min(x), median(x), max(x)))
state.range

# Example 3: Using mapply to compute a new variable
#---------------------------------------------------
# In this example, I want to find the population density for each state. 
# In order to do this, I want to divide population by area. 
# state.area and state.x77 are not from the same dataset, but that is fine as long as 
# the vectors are the same length and the data is in the same order. 
# Both vectors are alphabetically by state, so mapply can be used.

population <- state.x77[1:50]
population
area <- state.area
area
pop.dens <- mapply(function(x, y) x/y, population, area)
pop.dens


# Example 4: Using tapply to explore population by region
# --------------------------------------------------------
# In this example, I want to find out some information about the population of states split by region. 
# state.region is a factor with four levels: Northeast, South, North Central, and West. 
# For each region, I want the minimum, median, and maximum populations.

region.info <- tapply(population, state.region, function(x) c(min(x), median(x), max(x)))
region.info


