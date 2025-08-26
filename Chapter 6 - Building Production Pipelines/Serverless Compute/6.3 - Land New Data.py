# Databricks notebook source
# MAGIC %md
# MAGIC # Processing Change Data Capture

# COMMAND ----------

# MAGIC %run ../../Includes/Serverless-School-Setup

# COMMAND ----------

load_new_json_data()

# COMMAND ----------

# MAGIC %sql
# MAGIC -- SELECT * from json.`dbfs:/mnt/DE-Associate-Book/datasets/school/courses-cdc/02.json`
