# ==============================================================================
# ASSIGNMENT: Practical: Air-Quality Data Cleaning Using R
# ==============================================================================

# ------------------------------------------------------------------------------
# Task 1: Import and Inspect the Dataset
# ------------------------------------------------------------------------------
cat("--- Task 1: Import and Inspect the Dataset ---\n")
file_name <- "PRSA_Data_Aotizhongxin_20130301-20170228.csv"

# Using tryCatch to handle file import errors
air_quality <- tryCatch({
  read.csv(file_name)
}, error = function(e) {
  message("Error: The file is not found, cannot be opened, or the format is incorrect.")
  return(NULL)
})

if(!is.null(air_quality)) {
  # 1. Display the first six records
  print(head(air_quality))
  
  # 2. Display the structure of the dataset
  str(air_quality)
  
  # 3. Display the number of rows and columns
  cat("Number of rows:", nrow(air_quality), "\n")
  cat("Number of columns:", ncol(air_quality), "\n")
  
  # 4. Check whether the dataset contains missing values
  has_missing <- any(is.na(air_quality))
  cat("Contains missing values:", has_missing, "\n")
  
  # 5. Display the total number of missing values
  total_missing <- sum(is.na(air_quality))
  cat("Total missing values in dataset:", total_missing, "\n\n")
}

# ------------------------------------------------------------------------------
# Task 2: Understand NA, NULL, and NaN
# ------------------------------------------------------------------------------
cat("--- Task 2: Understand NA, NULL, and NaN ---\n")

# NA: Unavailable or missing observation
temperature <- c(28, 30, NA, 32)
cat("NA Example Output:", is.na(temperature), "\n")

# NULL: Absent or empty R object
missing_object <- NULL
cat("NULL Example Output:", is.null(missing_object), "\n")

# NaN: Undefined numerical result
undefined_value <- 0/0
cat("NaN Example Output:", is.nan(undefined_value), "\n\n")

# ------------------------------------------------------------------------------
# Task 3: Create a Missing-Value Summary Function
# ------------------------------------------------------------------------------
cat("--- Task 3: Missing-Value Summary Function ---\n")

missing_summary <- function(df, vars) {
  total_records <- nrow(df)
  summary_list <- list()
  
  for(v in vars) {
    if(v %in% names(df)) {
      miss_val <- sum(is.na(df[[v]]))
      miss_pct <- (miss_val / total_records) * 100
      
      if(miss_pct > 20) {
        warning(paste("Variable", v, "contains more than 20% missing values."))
      }
      
      summary_list[[v]] <- data.frame(Variable = v, 
                                      Total_Records = total_records, 
                                      Missing_Values = miss_val, 
                                      Missing_Percentage = round(miss_pct, 2))
    }
  }
  return(do.call(rbind, summary_list))
}

selected_vars <- c("PM2.5", "PM10", "SO2", "NO2", "TEMP", "WSPM", "wd")
miss_summary_table <- missing_summary(air_quality, selected_vars)
print(miss_summary_table)
cat("\n")

# ------------------------------------------------------------------------------
# Task 4: Identify Invalid Numerical Results
# ------------------------------------------------------------------------------
cat("--- Task 4: Identify Invalid Numerical Results ---\n")

# Create pollution ratio
air_quality$pollution_ratio <- air_quality$PM2.5 / air_quality$PM10

# Check for invalid states (displaying counts)
cat("NA count:", sum(is.na(air_quality$pollution_ratio)), "\n")
cat("NaN count:", sum(is.nan(air_quality$pollution_ratio)), "\n")
cat("Infinite count:", sum(is.infinite(air_quality$pollution_ratio)), "\n")

# Replace NaN and Infinite with NA
air_quality$pollution_ratio[is.nan(air_quality$pollution_ratio) | is.infinite(air_quality$pollution_ratio)] <- NA
cat("Replacement complete. New NA count in pollution_ratio:", sum(is.na(air_quality$pollution_ratio)), "\n\n")

# ------------------------------------------------------------------------------
# Task 8 Setup: Store "Before Cleaning" missing value counts
# ------------------------------------------------------------------------------
# We do this here before we modify the dataset in Tasks 5 and 6
missing_before <- sapply(air_quality[selected_vars], function(x) sum(is.na(x)))

# ------------------------------------------------------------------------------
# Task 5: Handle Missing Numerical Values Using a Loop
# ------------------------------------------------------------------------------
cat("--- Task 5: Handle Missing Numerical Values ---\n")
numeric_variables <- c("PM2.5", "PM10", "SO2", "NO2", "TEMP", "WSPM")

for(var in numeric_variables) {
  # 1. Check whether the column exists
  if(var %in% names(air_quality)) {
    # 2. Count missing values before
    missing_before_task5 <- sum(is.na(air_quality[[var]]))
    
    # 3. Calculate the median
    var_median <- median(air_quality[[var]], na.rm = TRUE)
    
    # 4. Replace missing values with median
    air_quality[[var]][is.na(air_quality[[var]])] <- var_median
    
    # 5. Display statistics
    missing_after_task5 <- sum(is.na(air_quality[[var]]))
    
    cat("Variable:", var, "\n")
    cat("  Missing before:", missing_before_task5, "\n")
    cat("  Median used:", var_median, "\n")
    cat("  Missing after:", missing_after_task5, "\n\n")
  }
}

# ------------------------------------------------------------------------------
# Task 6: Handle Missing Categorical Values
# ------------------------------------------------------------------------------
cat("--- Task 6: Handle Missing Categorical Values ---\n")

calculate_mode <- function(x) {
  unique_x <- unique(na.omit(x))
  unique_x[which.max(tabulate(match(na.omit(x), unique_x)))]
}

wd_missing_before <- sum(is.na(air_quality$wd))
wd_mode <- calculate_mode(air_quality$wd)
air_quality$wd[is.na(air_quality$wd)] <- wd_mode
wd_missing_after <- sum(is.na(air_quality$wd))

cat("Variable: wd\n")
cat("  Mode calculated:", wd_mode, "\n")
cat("  Missing before:", wd_missing_before, "\n")
cat("  Missing after:", wd_missing_after, "\n\n")

# ------------------------------------------------------------------------------
# Task 7: Implement Error Handling
# ------------------------------------------------------------------------------
cat("--- Task 7: Error Handling via clean_variable function ---\n")

clean_variable <- function(dataset, variable_name) {
  result <- tryCatch({
    # 1. Check whether variable exists
    if(!(variable_name %in% names(dataset))) {
      stop("Error: The variable does not exist in the dataset.")
    }
    
    target_var <- dataset[[variable_name]]
    
    # 2. Check if variable contains ONLY missing values
    if(all(is.na(target_var))) {
      stop("Error: The variable contains only missing values.")
    }
    
    # 3. Check whether variable is numerical
    if(!is.numeric(target_var)) {
      stop("Error: A categorical variable was passed instead of a numerical variable.")
    }
    
    # 4. Calculate median (checking if calculation is possible)
    var_med <- median(target_var, na.rm = TRUE)
    if(is.na(var_med)) {
      stop("Error: The median cannot be calculated.")
    }
    
    # 5. Replace and return
    target_var[is.na(target_var)] <- var_med
    message(paste("Successfully cleaned numerical variable:", variable_name))
    return(target_var)
    
  }, error = function(e) {
    message(e$message)
    return(NULL) # Return NULL on failure so program doesn't stop unexpectedly
  })
  
  return(result)
}

# Testing the error handling function (Intentional errors for demonstration)
cat("Testing with nonexistent variable:\n")
test1 <- clean_variable(air_quality, "FAKE_VAR")

cat("Testing with categorical variable 'wd':\n")
test2 <- clean_variable(air_quality, "wd")

# ------------------------------------------------------------------------------
# Task 8: Compare Missing Values Before and After Cleaning
# ------------------------------------------------------------------------------
cat("\n--- Task 8: Compare Missing Values Before and After ---\n")
missing_after <- sapply(air_quality[selected_vars], function(x) sum(is.na(x)))
values_replaced <- missing_before - missing_after

comparison_table <- data.frame(
  Variable = selected_vars,
  Missing_Before = missing_before,
  Missing_After = missing_after,
  Values_Replaced = values_replaced
)
print(comparison_table)
cat("\n")

# ------------------------------------------------------------------------------
# Task 9: Generate One Visualization
# ------------------------------------------------------------------------------
cat("--- Task 9: Generating Visualization ---\n")
# Prepare data matrix for barplot
bar_data <- rbind(comparison_table$Missing_Before, comparison_table$Missing_After)
colnames(bar_data) <- comparison_table$Variable
rownames(bar_data) <- c("Before Cleaning", "After Cleaning")

# Create Plot
png("missing_values_plot.png", width=800, height=600)
barplot(bar_data, 
        beside = TRUE, 
        col = c("coral", "lightgreen"),
        main = "Missing Values Before and After Data Cleaning",
        xlab = "Variables", 
        ylab = "Number of Missing Values",
        legend.text = TRUE,
        args.legend = list(x = "topright"))
dev.off()
cat("Visualization saved as 'missing_values_plot.png' in the working directory.\n\n")

# ------------------------------------------------------------------------------
# Task 10: Export the Cleaned Dataset
# ------------------------------------------------------------------------------
cat("--- Task 10: Export the Cleaned Dataset ---\n")
write.csv(air_quality, "cleaned_air_quality_data.csv", row.names = FALSE)
cat("Data successfully exported to 'cleaned_air_quality_data.csv'.\n")