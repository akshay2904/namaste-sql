WITH ranked AS (
    SELECT
        department,
        employee_id,
        name,
        salary,
        ROW_NUMBER() OVER (
            PARTITION BY department
            ORDER BY salary DESC, employee_id ASC
        ) AS row_num
    FROM employees
)
SELECT
    department,
    employee_id,
    name,
    salary,
    row_num
FROM ranked
WHERE row_num <= 2
ORDER BY department, row_num
