SELECT employee_id, name,
       COALESCE(department, 'Unknown') AS department,
       COALESCE(salary, 0) AS salary
FROM employees
WHERE COALESCE(salary, 0) > 0
ORDER BY employee_id
