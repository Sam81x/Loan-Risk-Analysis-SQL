CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    customer_id INT,
    loan_amount DECIMAL(10,2),
    interest_rate DECIMAL(5,2),
    loan_status VARCHAR(20),
    risk_grade VARCHAR(5),
    issue_date DATE,
    term_months INT
);
