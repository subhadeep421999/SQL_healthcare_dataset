use college13;
select * from healthcare_dataset;


-- 1. Average Treatment Cost per Disease
select disease_type, round(avg(treatment_cost_usd),2) as avg_treatment_cost
from healthcare_dataset
group by disease_type
order by avg_treatment_cost desc;


-- 2. Department-Wise Patient Count and Average Satisfaction
select hospital_department, count(*) as total_patients, round(avg(patient_satisfaction_score),2) as avg_satisfaction
from healthcare_dataset group by Hospital_Department order by avg_satisfaction desc;



-- 3. Gender Distribution by Disease
select disease_type, gender, count(*) as count from healthcare_dataset
group by disease_type, gender
order by disease_type, count desc;



-- 4. Patients Requiring Follow-up by Department
select hospital_department, sum(case when followup_required='Yes' then 1 else 0 end) as followup_patients,
round(sum(case when followup_required= 'Yes' then 1 else 0 end)*100/ count(*) ,2) as followup_percentage
from healthcare_dataset group by Hospital_Department
order by followup_percentage desc;



-- 5. Top 10 Most Expensive Treatments
select patient_id, disease_type, doctor_name, hospital_department,treatment_cost_usd
from healthcare_dataset
order by Treatment_Cost_USD desc limit 10;



-- 6. Blood Group Distribution
select blood_group, count(*) as total_patients,
round(count(*)*100 / (select count(*) from healthcare_dataset),2) as percentage
from healthcare_dataset
group by blood_group
order by total_patients desc;



-- 7. Correlation: Age vs. Satisfaction (Grouped by Age Range)
select case when age between 0 and 18 then '0-18'
            when age between 19 and 35 then '19-35'
            when age between 36 and 50 then '36-50'
            when age between 51 and 65 then '51-65'
            else '65+' 
            end as age_group,
round(avg(patient_satisfaction_score),2) as avg_satisfaction
from healthcare_dataset group by age_group
order by avg_satisfaction desc;




-- 8. Patients with Long Hospital Stay (>7 days)
select patient_id, disease_type, datediff(discharge_date, admission_date) as days_stayed, treatment_cost_USD
from healthcare_dataset where  datediff(discharge_date, admission_date) > 7
order by days_stayed desc;



-- 9. Most Common Medication by Disease
create table ranked_medication as
select disease_type, medication_prescribed, count(*) as times_prescribed,
rank() over( partition by disease_type order by count(*) desc) as rnk 
from healthcare_dataset 
group by disease_type, medication_prescribed;
select disease_type, medication_prescribed, times_prescribed 
from ranked_medication where rnk = 1;




-- 10. Insurance Coverage Impact on Cost
select insurance_provider, round(avg(treatment_cost_usd),2) as avg_cost
from healthcare_dataset group by insurance_provider
order by avg_cost asc;



-- 11. Window Function: Rank Diseases by Average Cost
select disease_type, round(avg(treatment_cost_usd),2) as avg_cost,
rank() over (order by avg(treatment_cost_usd) desc) as cost_rank
from healthcare_dataset group by disease_type;




-- 12. Average BMI by Department (Health Monitoring)
select hospital_department, round(avg(bmi),2) as avg_bmi
from healthcare_dataset group by hospital_department
order by avg_bmi desc;



-- 13. Doctor Performance — Avg Satisfaction per Doctor
select doctor_name, count(*) as total_patients, round(avg(patient_satisfaction_score),2) as avg_satisfaction
from healthcare_dataset group by doctor_name
having total_patients > 5
order by avg_satisfaction desc;




-- 14. Outlier Detection — Costly Treatments
select * from healthcare_dataset
where treatment_cost_usd > 
(select avg(treatment_cost_usd) + 2*stddev(treatment_cost_usd) from healthcare_dataset);




-- 15. Average Hospital Stay Duration by Disease
select disease_type, round(avg(datediff(discharge_date, admission_date)),2) as avg_stay_days
from healthcare_dataset group by disease_type
order by avg_stay_days desc;



















































