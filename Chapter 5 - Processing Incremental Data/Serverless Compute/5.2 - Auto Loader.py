# Databricks notebook source
# MAGIC %md
# MAGIC # Auto Loader in Action

# COMMAND ----------

# MAGIC %md-sandbox
# MAGIC
# MAGIC <div  style="text-align: center;">
# MAGIC   <img src="https://raw.githubusercontent.com/derar-alhussein/oreilly-databricks-dea/main/Includes/Images/school_schema.png" alt="School Schema">
# MAGIC </div>

# COMMAND ----------

# MAGIC %run ../../Includes/Serverless-School-Setup

# COMMAND ----------

files = dbutils.fs.ls(f"dbfs:/mnt/DE-Associate-Book/datasets/school/enrollments-json-raw")
display(files)

# COMMAND ----------

# MAGIC %md
# MAGIC
# MAGIC ## Setting up Auto Loader

# COMMAND ----------

(spark.readStream
           .format("cloudFiles")
           .option("cloudFiles.format", "json")
           .option("cloudFiles.inferColumnTypes","true")
           .option("cloudFiles.schemaLocation", "dbfs:/mnt/DEA-Book/checkpoints/enrollments")
           .load(f"dbfs:/mnt/DE-Associate-Book/datasets/school/enrollments-json-raw")
     .writeStream
           .option("checkpointLocation", "dbfs:/mnt/DEA-Book/checkpoints/enrollments")
           .trigger(availableNow=True)
           .table("enrollments_updates")
)

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT * FROM enrollments_updates

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT count(1) FROM enrollments_updates

# COMMAND ----------

# MAGIC %md
# MAGIC
# MAGIC ## Observing Auto Loader

# COMMAND ----------

load_new_data()

# COMMAND ----------

files = dbutils.fs.ls(f"{dataset_school}/enrollments-json-raw")
display(files)

# COMMAND ----------

# MAGIC %sql
# MAGIC CREATE TABLE enrollments_updates_2
# MAGIC AS SELECT * FROM json.`dbfs:/mnt/DE-Associate-Book/datasets/school/enrollments-json-raw`

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT * FROM enrollments_updates_2

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT count(*) FROM enrollments_updates

# COMMAND ----------

# MAGIC %md
# MAGIC
# MAGIC ## Exploring table history

# COMMAND ----------

# MAGIC %sql
# MAGIC DESCRIBE HISTORY enrollments_updates

# COMMAND ----------

# MAGIC %md
# MAGIC
# MAGIC ## Cleaning up

# COMMAND ----------

# MAGIC %md
# MAGIC To Research - AUTO LOADER Write with Trigger AvailableNow and Serverless Compute not triggering updates of Sink Table when new files arrive

# COMMAND ----------

# MAGIC %sql
# MAGIC DROP TABLE enrollments_updates

# COMMAND ----------

dbutils.fs.rm("dbfs:/mnt/DEA-Book/checkpoints/enrollments", True)

# COMMAND ----------


