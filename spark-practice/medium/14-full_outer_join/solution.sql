SELECT e.employee_id, e.name,
       COALESCE(e.department_id, d.department_id) AS department_id,
       d.department_name, d.budget
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.department_id
ORDER BY department_id ASC NULLS LAST, e.employee_id ASC
