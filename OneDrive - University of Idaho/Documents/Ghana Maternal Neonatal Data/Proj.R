library(dplyr)
library(purrr)
library(haven)
library(psych)

library(haven)
GHCH7IFL <- as.data.frame(read_sav("Data/GHCH7ISV/GHCH7IFL.SAV"))
View(GHCH7IFL)

readr::datasource("Data/GHCH7ISV/GHCH7IFL.SAV")
haven::read_sav("Data/GHCH7ISV/GHCH7IFL.SAV")

spss_labels(GHCH7IFL)


#GHBQ7IFL <- read_sav("C:/Users/jakes/OneDrive - University of Idaho/Documents/Ghana Maternal Neonatal Data/Data/GHBQ7ISV/GHBQ7IFL.SAV")
#View(GHBQ7IFL)
describe(spss_labels("C:/Users/jakes/OneDrive - University of Idaho/Documents/Ghana Maternal Neonatal Data/Data/GHBQ7ISV/GHBQ7IFL.SAV"))
describe(GHCH7IFL)#, exclude.missing = TRUE)
str(GHCH7IFL)

#summary(GHBQ7IFL)

filter_missing <- function(data) {
  threshold <- nrow(data) / 2
  filtered_data <- data[, colSums(is.na(data)) <= threshold]
  return(filtered_data)
}

df <- filter_missing(GHBQ7IFL)

names(df)
summary(df)


fill_mode <- function(data) {
  # Function to calculate the mode
  mode_func <- function(x) {
    unique_x <- unique(na.omit(x))
    unique_x[which.max(tabulate(match(x, unique_x)))]
  }
  
  # Apply the mode function to each column
  data_filled <- data
  for (col in names(data_filled)) {
    if (is.factor(data_filled[[col]])) {
      mode_value <- mode_func(data_filled[[col]])
      data_filled[[col]][is.na(data_filled[[col]])] <- mode_value
    }
  }
  
  return(data_filled)
}

fill_mode <- function(data) {
  # Function to calculate the mode
  mode_func <- function(x) {
    if (length(x) == 0) return(NA)
    unique_x <- unique(na.omit(x))
    unique_x[which.max(tabulate(match(x, unique_x)))]
  }
  
  # Apply the mode function to each column
  data_filled <- data
  for (col in names(data_filled)) {
    mode_value <- mode_func(data_filled[[col]])
    if (!is.na(mode_value)) {
      data_filled[[col]][is.na(data_filled[[col]])] <- mode_value
    }
  }
  
  return(data_filled)
}


# Example usage
# Assuming df is your data frame
filled_df <- fill_mode(GHCH7IFL)


# Example usage
# Assuming df is your data frame
filled_df <- fill_mode(GHCH7IFL)
summary(filled_df)
View(filled_df)


library(dplyr)
library(forcats)

# Convert haven_labelled objects to factors
filled_df <- filled_df %>%
  mutate(
    QREGION = as_factor(QREGION),
    PREGOUT = as_factor(PREGOUT)
  )

# Now create the cross-tabulation
xtabs(~ QREGION + PREGOUT, data = filled_df)



summary(xtabs(~filled_df$QREPREGOUT, data = filled_df))


# Load required libraries
library(ggplot2)

# Create a stacked bar plot
ggplot(filled_df, aes(x = QREGION, fill = PREGOUT)) +
  geom_bar(position = "fill") +  # position = "fill" gives proportional stacked bars
  labs(title = "Distribution of Pregnancy Outcomes Across Regions",
       x = "Region",
       y = "Proportion",
       fill = "Pregnancy Outcome") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Convert haven_labelled objects to factors
filled_df <- filled_df %>%
  mutate(
    QREGION = as_factor(QREGION),
    Q216 = as_factor(Q216)
  )

# Now create the cross-tabulation
xtabs(~ QREGION + Q216, data = filled_df)

summary(xtabs(~ QREGION + Q216, data = filled_df))


# Step 1: Create a contingency table for dead children (Q216 == "No")
dead_counts <- xtabs(~ QREGION + Q216, data = filled_df)[, "No"]
print(dead_counts)

# Step 2: Get the total counts for each region
total_counts <- rowSums(xtabs(~ QREGION + Q216, data = filled_df))
print(total_counts)

# Props. of dead
props <- (dead_counts/total_counts)

props

View(filled_df)



library(dplyr)
library(purrr)

real_data <- filled_df %>% filter(!is.na(PREGOUT))
View(real_data)
summary(real_data)

# Assuming df is your data frame
real_datadf <- real_data[, -c(1:18)]

# View the updated data frame
print(real_datadf)
View(real_datadf)

# Assuming df is your data frame
real_datadf <- real_datadf[, -c(21:40)]

# View the updated data frame
print(real_datadf)
View(real_datadf)


fill_mode <- function(data) {
  # Function to calculate the mode
  mode_func <- function(x) {
    unique_x <- unique(na.omit(x))
    unique_x[which.max(tabulate(match(x, unique_x)))]
  }
  
  # Apply the mode function to each column
  data_filled <- data
  for (col in names(data_filled)) {
    #if (is.factor(data_filled[[col]])) {
      mode_value <- mode_func(data_filled[[col]])
      data_filled[[col]][is.na(data_filled[[col]])] <- mode_value
    }
  }
  
  return(data_filled)
}

# Example usage
# Assuming df is your data frame
filled_df <- fill_mode(real_datadf)
summary(real_datadf)
View(real_datadf)


fill_mode <- function(data) {
  # Function to calculate the mode
  mode_func <- function(x) {
    unique_x <- unique(na.omit(x))
    unique_x[which.max(tabulate(match(x, unique_x)))]
  }
  
  # Apply the mode function to each column
  data_filled <- data
  for (col in names(data_filled)) {
    mode_value <- mode_func(data_filled[[col]])
    data_filled[[col]][is.na(data_filled[[col]])] <- mode_value
  }
  
  return(data_filled)
}

# Example usage
# Assuming df is your data frame
filled_df <- fill_mode(real_datadf)
print(real_datadf)
View(real_datadf)

install.packages("caret", dependencies = TRUE)
library(caret)
library(recipes)

one_hot_encode <- function(data) {
  # Identify categorical variables
  cat_vars <- data %>% select_if(is.factor) %>% colnames()
  
  # Create a recipe for the data
  rec <- recipe(~., data = data) %>%
    step_dummy(all_nominal(), -all_outcomes())
  
  # Prepare and bake the recipe
  data_encoded <- rec %>%
    prep(data = data) %>%
    bake(new_data = data)
  
  return(data_encoded)
}

# Example usage
# Assuming df is your data frame
encoded_df <- one_hot_encode(real_datadf)
print(encoded_df)
