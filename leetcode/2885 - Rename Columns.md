# 2885. Rename Columns

**Difficulty:** Easy
**Tags:** N/A
**Acceptance Rate:** 85.2%
**Access:** Free
**URL:** https://leetcode.com/problems/rename-columns/

---

DataFrame `students`
+-------------+--------+
| Column Name | Type   |
+-------------+--------+
| id          | int    |
| first       | object |
| last        | object |
| age         | int    |
+-------------+--------+

Write a solution to rename the columns as follows:

	
`id` to `student_id`

	
`first` to `first_name`

	
`last` to `last_name`

	
`age` to `age_in_years`

The result format is in the following example.

 

**Example 1:**
**Input:
**+----+---------+----------+-----+
| id | first   | last     | age |
+----+---------+----------+-----+
| 1  | Mason   | King     | 6   |
| 2  | Ava     | Wright   | 7   |
| 3  | Taylor  | Hall     | 16  |
| 4  | Georgia | Thompson | 18  |
| 5  | Thomas  | Moore    | 10  |
+----+---------+----------+-----+
**Output:**
+------------+------------+-----------+--------------+
| student_id | first_name | last_name | age_in_years |
+------------+------------+-----------+--------------+
| 1          | Mason      | King      | 6            |
| 2          | Ava        | Wright    | 7            |
| 3          | Taylor     | Hall      | 16           |
| 4          | Georgia    | Thompson  | 18           |
| 5          | Thomas     | Moore     | 10           |
+------------+------------+-----------+--------------+
**Explanation:** 
The column names are changed accordingly.

**Hints:**
1. Consider using a build-in function in pandas library with a dictionary to rename the columns as specified.

---

## Solution

```python

```
