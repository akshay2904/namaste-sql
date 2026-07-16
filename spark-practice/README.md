# Spark Practice — Problem Set

Extracted from **https://spark.vutrinh.net/problems** (backend `api.vutrinh.net`).

**65 problems** across easy / medium / hard. Each problem folder contains:

- `README.md` — problem statement, schema, sample input, hints, and official SQL + DataFrame solutions
- `solution.sql` — official Spark SQL solution
- `solution.py` — official PySpark DataFrame solution
- `sample_input.json` — sample input data (from the site's preview endpoint)

---

## Easy (11)

| # | Problem | Tags |
|---|---|---|
| 1 | [Group By Basics](easy/01-group_by_basics/README.md) | aggregation, groupby |
| 2 | [Find Duplicate Emails](easy/02-find_duplicates/README.md) | aggregation, groupby, filtering |
| 3 | [Handling NULLs](easy/03-handling_nulls/README.md) | null handling, coalesce |
| 4 | [Filter and Count](easy/04-filter_and_count/README.md) | filtering, aggregation, count distinct |
| 5 | [Categorize by Price](easy/05-categorize_by_price/README.md) | case when, conditional logic |
| 6 | [Combine Two Tables](easy/06-combine_tables/README.md) | union, set operations |
| 7 | [Column Arithmetic](easy/07-column_arithmetic/README.md) | derived columns, arithmetic, rounding |
| 8 | [Top N Overall](easy/08-top_n_overall/README.md) | ordering, limit |
| 9 | [String Basics](easy/09-string_basics/README.md) | string functions, data cleaning |
| 10 | [Daily Sales Total](easy/10-daily_sales/README.md) | aggregation, groupby, date functions |
| 11 | [Simple Inner Join](easy/11-simple_inner_join/README.md) | joins, filtering |

## Medium (35)

| # | Problem | Tags |
|---|---|---|
| 12 | [Customers with No Orders](medium/12-customers_no_orders/README.md) | joins, anti-join, left join |
| 13 | [Self Join — Find Manager](medium/13-self_join_manager/README.md) | joins, self-join |
| 14 | [Full Outer Join](medium/14-full_outer_join/README.md) | joins, full outer join, null handling |
| 15 | [Customers Who Bought Both](medium/15-customers_bought_both/README.md) | joins, intersect, filtering |
| 16 | [Unsold Products](medium/16-unsold_products/README.md) | joins, anti-join |
| 17 | [Most Popular Product per Category](medium/17-popular_product_category/README.md) | joins, window functions, ranking |
| 18 | [Multi-Table Join](medium/18-multi_table_join/README.md) | joins, aggregation |
| 19 | [Monthly Revenue Summary](medium/19-monthly_revenue/README.md) | aggregation, date functions |
| 20 | [Revenue Share per Category](medium/20-revenue_share/README.md) | aggregation, window functions, percentage |
| 21 | [Conditional Aggregation](medium/21-conditional_aggregation/README.md) | aggregation, case when |
| 22 | [Count Distinct Users per Day](medium/22-count_distinct_day/README.md) | aggregation, count distinct |
| 23 | [First and Last Event per User](medium/23-first_last_event/README.md) | aggregation, min max |
| 24 | [Pivot Attendance by Status](medium/24-pivot_attendance/README.md) | pivot, aggregation |
| 25 | [Customers Above Average Spend](medium/25-customers_above_avg/README.md) | aggregation, having, subquery |
| 26 | [Remove Statistical Outliers](medium/26-remove_outliers/README.md) | aggregation, statistics, percentile |
| 27 | [Top N per Group](medium/27-top_n_per_group/README.md) | window functions, ranking |
| 28 | [Running Total](medium/28-running_total/README.md) | window functions, aggregation |
| 29 | [Stock Price Daily Change](medium/29-stock_price_change/README.md) | window functions, lag |
| 30 | [Next Purchase Date](medium/30-next_purchase_date/README.md) | window functions, lead |
| 32 | [Employee Salary vs Department Average](medium/32-salary_vs_dept_avg/README.md) | window functions, avg over partition |
| 34 | [Dense Rank vs Rank](medium/34-dense_rank_vs_rank/README.md) | window functions, rank, dense_rank |
| 37 | [Monthly Active Users](medium/37-monthly_active_users/README.md) | date functions, count distinct |
| 38 | [Weekend vs Weekday Revenue](medium/38-weekend_vs_weekday/README.md) | date functions, case when |
| 39 | [Days Between Events](medium/39-days_between_events/README.md) | date functions, datediff |
| 40 | [Active Subscriptions on a Date](medium/40-active_subscriptions/README.md) | date functions, date range |
| 41 | [Late Deliveries](medium/41-late_deliveries/README.md) | date functions, datediff, filtering |
| 42 | [Aggregate Tags into Array](medium/42-aggregate_tags/README.md) | collect_list, spark specific |
| 43 | [Explode Tags to Rows](medium/43-explode_tags/README.md) | explode, array to rows |
| 44 | [Count Tags per Product](medium/44-count_tags_per_product/README.md) | explode, groupby |
| 45 | [Filter Users by Interest](medium/45-filter_array/README.md) | array_contains, filtering |
| 48 | [Extract Email Domain](medium/48-extract_email_domain/README.md) | string functions, regexp_extract |
| 49 | [Mask PII Data](medium/49-mask_pii/README.md) | string functions, regexp_replace |
| 50 | [Split and Count Words](medium/50-split_count_words/README.md) | split, explode, string functions |
| 51 | [Standardize Phone Numbers](medium/51-standardize_phones/README.md) | regexp_replace, string functions |
| 58 | [Top N with Tie-Breaking](medium/58-top_n_tiebreak/README.md) | window functions, row_number, tie-breaking |

## Hard (19)

| # | Problem | Tags |
|---|---|---|
| 31 | [7-Day Rolling Average](hard/31-rolling_average/README.md) | window functions, rolling, rows between |
| 33 | [Percentile Rank of Sales](hard/33-percentile_rank/README.md) | window functions, percent_rank, ntile |
| 35 | [Year-over-Year Revenue Growth](hard/35-yoy_growth/README.md) | window functions, lag, year over year |
| 36 | [Top Customers by Region](hard/36-top_customers_region/README.md) | window functions, rank, nested partition |
| 46 | [Most Common Tag per Category](hard/46-most_common_tag/README.md) | explode, rank, spark specific |
| 47 | [Merge Arrays Across Rows](hard/47-merge_arrays/README.md) | collect_list, flatten, spark specific |
| 52 | [Sessionize Clickstream Data](hard/52-sessionize_clickstream/README.md) | window functions, session, lag |
| 53 | [Consecutive Attendance Streaks](hard/53-consecutive_streaks/README.md) | window functions, islands and gaps |
| 54 | [Funnel Analysis](hard/54-funnel_analysis/README.md) | window functions, ordered events, aggregation |
| 55 | [Customer Loyalty Score](hard/55-customer_loyalty/README.md) | aggregation, joins, composite scoring |
| 56 | [Tally Election Results](hard/56-tally_election/README.md) | aggregation, ranking, dense_rank |
| 57 | [Ledger Reconciliation](hard/57-ledger_reconciliation/README.md) | full outer join, variance |
| 59 | [Cohort Retention Analysis](hard/59-cohort_retention/README.md) | window functions, date functions, cohort |
| 60 | [Parse JSON Column](hard/60-parse_json_column/README.md) | json, from_json, spark specific |
| 61 | [Flatten Nested Structs](hard/61-flatten_structs/README.md) | structs, getField, spark specific |
| 62 | [ETL Job Statistics](hard/62-etl_job_stats/README.md) | window functions, aggregation, analytics |
| 63 | [Products with Increasing YoY Sales](hard/63-increasing_yoy_sales/README.md) | window functions, lag, year over year |
| 64 | [Slowly Changing Dimension Type 2](hard/64-scd_type2_detection/README.md) | window functions, scd, data warehousing |
| 65 | [Slowly Changing Dimension Type 2 Modelling](hard/65-scd_type2_modelling/README.md) | window functions, scd, data modelling |
