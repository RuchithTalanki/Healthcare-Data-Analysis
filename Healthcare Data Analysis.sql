
use Heathcare_data;

-- 1.Average billing amount for each Hospital
SELECT 
    Hospital, ROUND(AVG(Billing_Amount), 2) AS Avg_Bill
FROM
    healthcare_data
GROUP BY Hospital
ORDER BY Avg_Bill DESC
LIMIT 10;

-- 2.Top 10 doctors with most patients treated?
SELECT 
    Doctor, COUNT(Name) AS patients_count
FROM
    healthcare_data
GROUP BY Doctor
ORDER BY patients_count DESC
LIMIT 10;

# Medical Conditions and Outcomes:

 -- 3. What are the top 5 most common medical conditions treated across all hospitals?
 
WITH ConditionRank AS (
    SELECT 
        Medical_Condition, 
        COUNT(Medical_Condition) AS Condition_Count,
        RANK() OVER (ORDER BY COUNT(Medical_Condition) DESC) AS rank_position
    FROM healthcare_data
    GROUP BY Medical_Condition
)
SELECT 
    rank_position, Medical_Condition, Condition_Count
FROM
    ConditionRank
WHERE
    rank_position <= 5
ORDER BY rank_position;

-- 4.Analyze the most common medical conditions for patients admitted in urgent vs elective vs Emergency cases.
SELECT 
    Admission_Type,
    Medical_Condition,
    COUNT(Medical_Condition) AS Condition_Count
FROM
    healthcare_data
WHERE
    Admission_Type IN ('Urgent' , 'Elective', 'Emergency')
GROUP BY Admission_Type , Medical_Condition
ORDER BY Admission_Type , Condition_Count DESC;

-- 5. What are the top 3 medications prescribed for cancer patients?
SELECT 
    Medical_Condition,
    Medication,
    COUNT(Medication) count_of_patients
FROM
    healthcare_data
WHERE
    Medical_Condition = 'Cancer'
GROUP BY Medical_Condition , Medication
ORDER BY count_of_patients DESC
LIMIT 3;

-- 6. Calculate the average billing amount for patients who received paracetamol versus ibuprofen.
SELECT 
    Medication, ROUND(AVG(Billing_Amount), 2) AS average_bill
FROM
    healthcare_data
WHERE
    Medication IN ('paracetamol' , 'ibuprofen')
GROUP BY Medication
ORDER BY average_bill DESC;

-- 7. Find the average length of stay for patients admitted in each hospital.
SELECT 
    AVG(DATEDIFF(Discharge_Date, Date_of_Admission))
FROM
    healthcare_data;

-- 8.Identify the busiest months for hospital admissions across all hospitals.
SELECT 
    MONTHNAME(Date_of_Admission) AS Monthname,Hospital,
    SUM(COUNT(Date_of_Admission)) OVER (PARTITION BY MONTHNAME(Date_of_Admission)) AS total_admissions
FROM 
    healthcare_data
GROUP BY 
    MONTHNAME(Date_of_Admission),Hospital
ORDER BY 
    total_admissions DESC
LIMIT 1;

-- 9. Calculate the total billing amount for each insurance provider.
SELECT 
    Insurance_Provider,
    ROUND(SUM(Billing_Amount), 2) AS Total_Bill
FROM
    healthcare_data
GROUP BY Insurance_Provider;

-- 10. Find out if there is a difference in average billing amount for urgent vs emergency admissions.
SELECT 
    Admission_Type,
    ROUND(AVG(Billing_Amount), 2) AS Average_Bill
FROM
    healthcare_data
WHERE
    Admission_Type IN ('urgent' , 'emergency')
GROUP BY Admission_Type;

-- 11. What is the most common blood type among patients diagnosed with diabetes?
SELECT 
    Blood_Type, COUNT(Medical_Condition) AS count_patients
FROM
    healthcare_data
WHERE
    Medical_Condition = 'diabetes'
GROUP BY Blood_Type
ORDER BY count_patients DESC
LIMIT 3;

-- 12. Calculate the average age of patients diagnosed with cancer.
SELECT 
    Medical_Condition, ROUND(AVG(age), 2) AS Average_age
FROM
    healthcare_data
WHERE
    Medical_Condition = 'cancer';

-- 13. Analyze the relationship between patient age and test results (normal, abnormal, inconclusive).
SELECT 
    CASE
        WHEN age BETWEEN 0 AND 20 THEN '0-20'
        WHEN age BETWEEN 21 AND 40 THEN '21-40'
        WHEN age BETWEEN 41 AND 60 THEN '41-60'
        ELSE '61+'
    END AS age_group,
    Test_Results,
    COUNT(*) AS result_count
FROM
    healthcare_data
GROUP BY age_group , Test_Results
ORDER BY age_group , Test_Results;


















 
