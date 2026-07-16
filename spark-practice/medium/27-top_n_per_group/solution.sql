SELECT department, employee, salary, rank
FROM (
  SELECT department, employee, salary,
         RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
  FROM employees
)
WHERE rank <= 2
ORDER BY department, rank
