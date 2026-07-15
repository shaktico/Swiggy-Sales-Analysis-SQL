# Swiggy Sales Analysis Using SQL

## About the Project

I created this project to analyze Swiggy food delivery data using Microsoft SQL Server.

In this project, I cleaned the raw data, removed duplicate records and created a star schema using dimension and fact tables. After preparing the data, I performed different analyses to understand order trends, revenue, restaurant performance, food categories and customer spending patterns.

## Tools Used

- Microsoft SQL Server
- SQL Server Management Studio
- SQL
- Excel

## Project Process

### 1. Data Cleaning

- Checked null values
- Checked blank values
- Identified duplicate records
- Removed duplicate records using `ROW_NUMBER()`

### 2. Data Modeling

Created a star schema using the following tables:

- `dim_date`
- `dim_location`
- `dim_restaurant`
- `dim_category`
- `dim_dish`
- `fact_swiggy_orders`

## KPIs

- Total Orders
- Total Revenue
- Average Dish Price
- Average Rating

## Analysis Performed

- Monthly order trends
- Quarterly order trends
- Year-wise order analysis
- Day-wise order patterns
- Top 10 cities by orders
- Revenue contribution by state
- Top 10 restaurants
- Category performance
- Most ordered dishes
- Orders and average ratings by cuisine
- Customer spending analysis
- Rating distribution

## SQL Concepts Used

- SELECT
- WHERE
- GROUP BY
- ORDER BY
- Aggregate Functions
- JOINS
- CASE Statements
- CTEs
- ROW_NUMBER
- Window Functions
- Subqueries
- Star Schema
- Primary and Foreign Keys

## What I Learned

Through this project, I improved my knowledge of SQL data cleaning, dimensional modeling and business analysis.

I also learned how to create dimension and fact tables, build relationships using primary and foreign keys and convert business requirements into SQL queries.

## Project Files

- `SQL_Swiggy_Analysis.sql` – Contains data cleaning, star schema creation and analysis queries
- `Swiggy_Data.csv` – Dataset used for the project

## Created By

**Shakti Singh Rajput**

[LinkedIn Profile](https://www.linkedin.com/in/shakti-singh-95860b3ab)
