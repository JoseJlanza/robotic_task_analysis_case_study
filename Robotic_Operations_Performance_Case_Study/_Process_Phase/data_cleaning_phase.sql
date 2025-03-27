--- overview of dataset/data cleaning phase---
/*
SELECT *
FROM `robotic-ops-performance-101101.robotic_operation.robotic_task_data` LIMIT 10
*/

---Query to identify key columns--
-- Determine which columns are relevant for our analysis. Based on our objectives, we’re looking for: Task duration: measures efficiency. Error logs: Indicicates failure rates. Task type: Help catogorize. Timestamp: Enables trend analysis. Robot ID: Allows us to analyze per-machine perfomance.--
/*
SELECT
  column_name,data_type
FROM `robotic-ops-performance-101101.robotic_operation.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'robotic_task_data';
*/

--Data Quality Checks--
--check for:Missing values,Outliers in processing time and accuracy, Potential data inconsistencies (e.g., negative or zero values in Processing_Time_s_ or Accuracy_%_)

--Query checks for missing values---
/*
SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN Robot_ID IS NULL THEN 1 ELSE 0 END) AS missing_Robot_ID,
  SUM(CASE WHEN Task_Type IS NULL THEN 1 ELSE 0 END) AS missing_Task_Type,
  SUM(CASE WHEN `Processing_Time _s_` IS NULL THEN 1 ELSE 0 END) AS missing_Processing_Time,
  SUM(CASE WHEN `Accuracy _%_` IS NULL THEN 1 ELSE 0 END) AS missing_Accuracy,
  SUM(CASE WHEN `Energy_Consumption _kWh_` IS NULL THEN 1 ELSE 0 END) AS missing_Energy_Consumption

FROM `robotic-ops-performance-101101.robotic_operation.robotic_task_data`---output is 0 in all columns.--
*/

--Check for Outliers (Processing Time & Accuracy)--
--this query identifies extreme values in Processing_Time _s_ and Accuracy _%_--
/*
SELECT
  MIN(`Processing_Time _s_`) AS min_processing_time,
  MAX(`Processing_Time _s_`) AS max_processing_time,
  APPROX_QUANTILES(`Processing_Time _s_`,4) [OFFSET(1)] AS q1_processing_time,
  APPROX_QUANTILES(`Processing_Time _s_`,4) [OFFSET(2)] AS median_processing_time,
  APPROX_QUANTILES(`Processing_Time _s_`,4) [OFFSET(3)] AS q3_processing_time,

  MIN(`Accuracy _%_`) AS min_accuracy,
  MAX(`Accuracy _%_`) AS max_processing_time,
  APPROX_QUANTILES(`Accuracy _%_`,4) [OFFSET(1)] AS q1_accuracy,
  APPROX_QUANTILES(`Accuracy _%_`,4) [OFFSET(2)] AS median_accuracy,
  APPROX_QUANTILES(`Accuracy _%_`,4) [OFFSET(3)] AS q3_accuracy,

FROM `robotic-ops-performance-101101.robotic_operation.robotic_task_data`; -- no outliers present
*/

---Identify Data Inconsistencies--
---check for negative values or invalid percentages---
/*
SELECT *
FROM `robotic-ops-performance-101101.robotic_operation.robotic_task_data` 
  WHERE `Processing_Time _s_` < 0
  OR `Accuracy _%_` < 0 
  OR `Accuracy _%_` > 100; -- output: no data to display--
*/
--data cleaning complete: No missing values, no extreme outliers or inconsistiencies detected,data appears well structured and ready for analysis-->Analysis phase
