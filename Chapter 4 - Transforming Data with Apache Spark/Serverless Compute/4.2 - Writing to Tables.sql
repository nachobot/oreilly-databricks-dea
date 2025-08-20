-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Writing to Tables

-- COMMAND ----------

-- MAGIC %md-sandbox
-- MAGIC
-- MAGIC <div  style="text-align: center;">
-- MAGIC   <img src="https://raw.githubusercontent.com/derar-alhussein/oreilly-databricks-dea/main/Includes/Images/school_schema.png" alt="School Schema">
-- MAGIC </div>

-- COMMAND ----------

-- MAGIC %run ../../Includes/Serverless-School-Setup

-- COMMAND ----------

CREATE TABLE enrollments AS
SELECT * FROM parquet.`dbfs:/mnt/DE-Associate-Book/datasets/school/enrollments`

-- COMMAND ----------

SELECT * FROM enrollments

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Replacing Data

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 1. CREATE OR REPLACE TABLE statement

-- COMMAND ----------

CREATE OR REPLACE TABLE enrollments AS
SELECT * FROM parquet.`dbfs:/mnt/DE-Associate-Book/datasets/school/enrollments`

-- COMMAND ----------

DESCRIBE HISTORY enrollments

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### 2. INSERT OVERWRITE

-- COMMAND ----------

INSERT OVERWRITE enrollments
SELECT * FROM parquet.`dbfs:/mnt/DE-Associate-Book/datasets/school/enrollments`

-- COMMAND ----------

DESCRIBE HISTORY enrollments

-- COMMAND ----------

 -- INSERT OVERWRITE enrollments
 -- SELECT *, input_file_name() FROM parquet.`dbfs:/mnt/DE-Associate-Book/datasets/school/enrollments`

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Appending Data

-- COMMAND ----------

INSERT INTO enrollments
SELECT * FROM parquet.`dbfs:/mnt/DE-Associate-Book/datasets/school/enrollments-new`

-- COMMAND ----------

SELECT count(1) FROM enrollments

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Merging Data

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW students_updates AS
SELECT * FROM json.`dbfs:/mnt/DE-Associate-Book/datasets/school/students-json-new`;

-- COMMAND ----------

MERGE INTO students c
USING students_updates u
ON c. student_id = u. student_id
WHEN MATCHED AND c.email IS NULL AND u.email IS NOT NULL THEN
 UPDATE SET email = u.email, updated = u.updated
WHEN NOT MATCHED THEN INSERT *

-- COMMAND ----------

-- MAGIC %python
-- MAGIC files = dbutils.fs.ls("dbfs:/mnt/DE-Associate-Book/datasets/school/courses-csv")
-- MAGIC display(files)

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS courses
(course_id STRING, title STRING, instructor STRING,
   category STRING, price DOUBLE)
USING CSV
OPTIONS (
  path = "dbfs:/mnt/DE-Associate-Book/datasets/school/courses-csv",
  header = "true",
  delimiter = ";"
  );


-- COMMAND ----------

DESCRIBE EXTENDED courses

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW courses_updates
  (course_id STRING, title STRING, instructor STRING,
   category STRING, price DOUBLE)
USING CSV
OPTIONS (
 path = "dbfs:/mnt/DE-Associate-Book/datasets/school/courses-csv-new",
 header = "true",
 delimiter = ";"
);

-- COMMAND ----------

MERGE INTO courses c
USING courses_updates u
ON c.course_id = u.course_id AND c.title = u.title
WHEN NOT MATCHED AND u.category = 'Computer Science' THEN
 INSERT *

-- COMMAND ----------


