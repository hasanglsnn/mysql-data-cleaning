# MySQL Data Cleaning Pipeline 🧹

This repository demonstrates a comprehensive data cleaning and standardization process using **MySQL**. The project focuses on transforming messy, inconsistent datasets into a structured and reliable format for further analysis.

### 🎯 Project Objective
The main goal of this project is to resolve data integrity issues, specifically targeting:
- Inconsistent date formats (identifying and standardizing various month/year arrangements and symbols).
- String and text irregularities.

### 🛠️ Technical Approach & Skills Demonstrated
I prefer a highly controlled, step-by-step execution approach to ensure data integrity and avoid irreversible errors. Key techniques used in this project include:
- **Pattern Matching:** Utilizing specific `LIKE` operators (e.g., precise underscore and wildcard combinations) to isolate distinct date formats.
- **Data Standardization:** Converting string-based dates into standard SQL DATE formats.
- **Data Integrity:** Step-by-step update execution.

### 📂 Repository Contents
- `layoffs.csv`: The initial, uncleaned dataset containing inconsistencies.
- `clean_laoffs.csv`: The final dataset after the cleaning process.
- `cleaning_code.sql`: The SQL script containing the step-by-step queries used for the transformation.
