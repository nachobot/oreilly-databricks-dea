-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Examining DLT pipelines

-- COMMAND ----------

USE CATALOG daniella

-- COMMAND ----------

-- MAGIC %python
-- MAGIC ## Hive Metastore %fs ls "dbfs:/mnt/DEA-Book/dlt"
-- MAGIC dbutils.fs.ls("abfss://sampledata@demo25db.dfs.core.windows.net/")

-- COMMAND ----------

-- SELECT * FROM delta.`dbfs:/mnt/DEA-Book/dlt/system/events`

-- COMMAND ----------

-- %fs ls dbfs:/mnt/DEA-Book/dlt/schemas/school_dlt_db/tables

-- COMMAND ----------

SELECT * FROM default.uk_daily_student_courses
