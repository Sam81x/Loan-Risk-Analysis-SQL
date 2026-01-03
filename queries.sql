
-- 1. Total loans by purpose
SELECT loan_purpose, COUNT(*) AS total_loans
FROM loan_risk
GROUP BY loan_purpose;

-- 2. Average loan amount by branch
SELECT branch, ROUND(AVG(loan_amount), 2) AS avg_loan_amount
FROM loan_risk
GROUP BY branch;

-- 3. Top 5 customers with highest loan amounts
SELECT customer_id, customer_name, loan_amount
FROM loan_risk
ORDER BY loan_amount DESC
LIMIT 5;

-- 4. Average interest rate by payment status
SELECT payment_status, ROUND(AVG(interest_rate), 2) AS avg_interest_rate
FROM loan_risk
GROUP BY payment_status;

-- 5. Branch with highest number of defaulted loans
SELECT branch, COUNT(*) AS defaulted_loans
FROM loan_risk
WHERE payment_status = 'Defaulted'
GROUP BY branch
ORDER BY defaulted_loans DESC
LIMIT 1;

-- 6. Monthly trend of loan applications
SELECT FORMAT_DATE('%Y %B', application_date) AS application_month, COUNT(*) AS total_applications
FROM loan_risk
GROUP BY application_month
ORDER BY MIN(application_date);

-- 7. Average income and age of customers who defaulted
SELECT ROUND(AVG(income), 2) AS avg_income, ROUND(AVG(age), 2) AS avg_age
FROM loan_risk
WHERE payment_status = 'Defaulted';

-- 8. Customers who paid on time and borrowed > 40K
SELECT customer_id, customer_name, loan_amount
FROM loan_risk
WHERE payment_status = 'On Time' AND loan_amount > 40000;

-- 9. Total loan amount and avg term by loan purpose
SELECT loan_purpose, SUM(loan_amount) AS total_loan_amount, ROUND(AVG(loan_term_months), 2) AS avg_loan_term
FROM loan_risk
GROUP BY loan_purpose;

-- 10. Percentage of loan amounts by payment status (using window function)
SELECT payment_status,
       ROUND(SUM(loan_amount) * 100.0 / SUM(SUM(loan_amount)) OVER (), 2) AS loan_percentage
FROM loan_risk
GROUP BY payment_status;

-- Risk segmentation based on loan status and amount
WITH risk_summary AS (
    SELECT
        risk_grade,
        COUNT(*) AS total_loans,
        SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) AS defaulted_loans,
        SUM(loan_amount) AS total_exposure
    FROM loans
    GROUP BY risk_grade
)
SELECT
    risk_grade,
    total_loans,
    defaulted_loans,
    ROUND(defaulted_loans * 100.0 / total_loans, 2) AS default_rate_pct,
    total_exposure
FROM risk_summary
ORDER BY default_rate_pct DESC;

