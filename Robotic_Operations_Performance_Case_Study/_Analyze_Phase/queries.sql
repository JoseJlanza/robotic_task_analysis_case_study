-Start to data analysis phase---
--Failure Rate per Task Type-
--This metric helps analyze how often a task results in defects or failures--
--Formula: Failure Rate= Defect Detected Count/Total Tasks per Task Type * 100
--query--
/*
SELECT
  `Task_Type`,
  COUNT(*) as total_tasks,
  SUM(CASE WHEN Defect_Detected = TRUE THEN 1 ELSE 0 END) AS defect_count,
  ROUND((SUM(CASE WHEN  Defect_Detected = TRUE THEN 1 ELSE 0 END)* 100.0) / COUNT(*), 2) AS failure_rate_percentage
FROM `robotic-ops-performance-101101.robotic_operation.robotic_task_data`
GROUP BY Task_Type
ORDER BY failure_rate_percentage DESC;
*/

--- Processing Time Analysis---
--- analyze which tasks take the longest to complete, which will help us identify inefficiencies----
--query--
/*
SELECT
  Task_Type,
  COUNT(*) AS total_tasks,
  ROUND(AVG(`Processing_Time _s_`),2) AS avg_processing_time_s
FROM `robotic-ops-performance-101101.robotic_operation.robotic_task_data`
GROUP BY Task_Type
ORDER BY  avg_processing_time_s DESC;
--output:avg_processing_time_s: 1.Painting 2.Assembly 3.Welding 4. Inspection----
*/
-- Painting and Assembly take the longest, with Assembly also having the highest failure rate(query1). Since the difference in processing time across tasks is not drastic, the next logical step is to identify potential bottlenecks by analyzing human intervention rates and environmental conditions--
-- query to see if Assembly requires more human assistance, which might slow it down--
/*
SELECT
  Task_Type,
  COUNT(*) AS total_tasks,
  SUM(CASE WHEN Human_Intervention_Needed = TRUE THEN 1 ELSE 0 END) AS intervention_count,
  ROUND((SUM(CASE WHEN Human_Intervention_Needed =  TRUE THEN 1 ELSE 0 END) * 100.0)/ COUNT(*),2) AS intervention_rate_percentage
FROM `robotic-ops-performance-101101.robotic_operation.robotic_task_data`
GROUP BY Task_Type 
ORDER BY intervention_rate_percentage DESC; --Output: highest intervention and perctage rate is Assembly(1) followed by painting(2)--