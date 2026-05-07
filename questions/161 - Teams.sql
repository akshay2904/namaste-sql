-- ======================================================================
-- 161 - Teams
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Linkedin
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/161-teams
-- ======================================================================

/*
Write a query to return a list of teams for each city. Teams are formed within these rules :

1. team members must live in the city they represent.
2. for each city, create teams of 3 until there are fewer than 3 who are unassigned.
3. when there are fewer than 3 people unassigned in a city, they form a team.

Report requirements :

1. There should be 3 columns : city name, a comma-delimited list of up to 3 players and the team's name.
2. the city should be ordered alphabetically
3. Players are selected in the order they occur in the table.
4. Player names should be ordered alphabetically within the comma-delimited list.
5. Team names are 'Team' plus a number.
For example, the first row's team is Team1, then Team2 and so on….

 
Table: emp_details
+-------------+----------+
| COLUMN_NAME | DATA_TYPE|
+-------------+----------+
| emp_name    | VARCHAR  |
| city        | VARCHAR  |
+-------------+----------+
*/


-- Write your SQL solution below:

```sql
WITH ranked_employees AS (
  -- Rank employees within each city in table order
  SELECT 
    emp_name,
    city,
    ROW_NUMBER() OVER (PARTITION BY city ORDER BY rowid) as emp_rank
  FROM emp_details
),
team_assignments AS (
  -- Assign team numbers based on groups of 3
  SELECT 
    emp_name,
    city,
    emp_rank,
    CEIL(emp_rank::FLOAT / 3) as team_num
  FROM ranked_employees
),
team_data AS (
  -- Aggregate employees into teams with sorted names
  SELECT 
    city,
    team_num,
    STRING_AGG(emp_name, ', ' ORDER BY emp_name) as player_list
  FROM team_assignments
  GROUP BY city, team_num
),
final_teams AS (
  -- Generate global team names
  SELECT 
    city,
    player_list,
    'Team' || ROW_NUMBER() OVER (ORDER BY city, team_num) as team_name
  FROM team_data
)
SELECT 
  city,
  player_list,
  team_name
FROM final_teams
ORDER BY city, team_name;
```
