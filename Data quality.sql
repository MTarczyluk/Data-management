# Incident Zip field

# Missing (NULL) values

SELECT COUNT(*) / (SELECT SUM(Count) FROM nyc311.sr_incident_zip_summary) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE `Incident Zip` IS NULL;

# Correct Zip length (5 digits)

SELECT COUNT(*) / (SELECT SUM(Count) FROM nyc311.sr_incident_zip_summary) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE LENGTH(`Incident Zip`) = 5 and `Incident Zip` REGEXP '^[0-9]+$';

# Accuracy of the Zip codes

SELECT COUNT(*) / (SELECT SUM(Count) FROM nyc311.sr_incident_zip_summary) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE (`Incident Zip` IS NOT NULL AND LENGTH(`Incident Zip`) = 5) 
AND NOT EXISTS
(SELECT 1 FROM nyc311.zip_code_nyc_borough
WHERE `Incident Zip` = Zip);

# Dates fields

# Missing Values

SELECT COUNT(*) / (SELECT COUNT(*) FROM nyc311.service_request) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE `Created Date` IS NULL;

SELECT COUNT(*) / (SELECT COUNT(*) FROM nyc311.service_request) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE `Closed Date` IS NULL;

SELECT COUNT(*) / (SELECT COUNT(*) FROM nyc311.service_request) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE `Due Date` IS NULL;

# Date consistency

SELECT COUNT(*) / (SELECT COUNT(*) FROM nyc311.service_request) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE `Closed Date` < `Created Date`;

SELECT COUNT(*) / (SELECT COUNT(*) FROM nyc311.service_request) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE `Due Date` < `Created Date`;

# Is the data format correct / valid? 

SELECT COUNT(*) / (SELECT COUNT(*) FROM nyc311.service_request) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE DATE(str_to_date(`Created Date`, '%Y-%m-%d')) IS NOT NULL
AND `Created Date` NOT REGEXP '^[0-9\.]+$';

SELECT COUNT(*) / (SELECT COUNT(*) FROM nyc311.service_request) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE DATE(str_to_date(`Closed Date`, '%Y-%m-%d')) IS NOT NULL
AND `Closed Date` NOT REGEXP '^[0-9\.]+$';

SELECT COUNT(*) / (SELECT COUNT(*) FROM nyc311.service_request) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE DATE(str_to_date(`Due Date`, '%Y-%m-%d')) IS NOT NULL
AND `Due Date` NOT REGEXP '^[0-9\.]+$';

# Unrecorded time

SELECT COUNT(*) / (SELECT COUNT(*) FROM nyc311.service_request) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE `Created Date` REGEXP '00:00:00';

SELECT COUNT(*) / (SELECT COUNT(*) FROM nyc311.service_request) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE `Closed Date` REGEXP '00:00:00';

SELECT COUNT(*) / (SELECT COUNT(*) FROM nyc311.service_request) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE `Due Date` REGEXP '00:00:00';

# Complaint Type Domain

# NULL or empty string values

SELECT COUNT(*) / (SELECT SUM(Count) FROM nyc311.sr_complaint_type_summary) * 100 AS "Metric Value"
FROM nyc311.service_request
where `Complaint Type` is null or `Complaint Type` = '';

# Accuracy of Complaint type data

SELECT COUNT(*) / (SELECT SUM(Count) FROM nyc311.sr_complaint_type_summary) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE NOT EXISTS
(SELECT 1 FROM nyc311.ref_sr_type_nyc311_open_data_26
WHERE `Complaint Type` = Type) 
AND `Complaint Type` NOT REGEXP '^[A-Za-z0-9 ]+$';

# Borough Domain

# Empty or unspecified values

SELECT COUNT(*) / (SELECT COUNT(*) FROM nyc311.service_request) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE Borough = 'Unspecified' or Borough IS NULL;

# Are the Boroughs accurate

SELECT COUNT(*) / (SELECT COUNT(*) FROM nyc311.service_request) * 100 AS "Metric Value"
FROM nyc311.service_request
WHERE NOT EXISTS
(SELECT 1 FROM nyc311.zip_code_nyc_borough
WHERE Borough = Borough AND `Incident Zip` = Zip);