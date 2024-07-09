## Sentinelone Task: Load issues to BQ

<small>Date: 2024-07-09
Written by: Josef Samanek</small>

## Considered solutions


### Option 1: Cloud Function + Scheduler

**Pros:**

* Simple and serverless.
* Easy to set up and manage.
* Can handle custom Python transformations.
* Cost-effective for small to medium workloads.

**Cons:**

* Limited by the execution time and memory of Cloud Functions.
* Managing complex workflows can be challenging.
* Debugging and logging might be less comprehensive compared to other options.


### Option 2: BigQuery Scheduled Queries

**Pros:**

* Fully managed and serverless.
* Easy to set up scheduled queries for both loading and transformation.
* No additional infrastructure required.
* Cost-effective for small to medium workloads.

**Cons:**

* Limited transformation capabilities compared to custom Python scripts.
* Complex transformations might be harder to achieve with SQL alone.
* Requires the data to be structured in a way that BigQuery can natively query.


### Option 3: Dataflow

**Pros:**

* Highly scalable and can handle large datasets.
* Allows for complex transformations using Apache Beam (Python, Java).
* Provides powerful monitoring and logging capabilities.
* Can handle both batch and streaming data.

**Cons:**

* More complex to set up and manage.
* Higher learning curve compared to other options.
* May incur higher costs, especially for smaller datasets.


### Option 4: Airflow / Cloud Composer

**Pros:**

* Highly flexible and allows for complex workflow management.
* Supports Python, which is great for custom transformations.
* Extensive monitoring and logging capabilities.
* Can orchestrate tasks across various GCP services.

**Cons:**

* Requires setting up and managing an Airflow environment.
* More complex to configure and maintain.
* Can be overkill for simple or small-scale workflows.


## Chosen solution

Given the task is quite straight-forward, has no complex dependencies, and all the transformations can be easily done in SQL, I decided to go with **Option 2: BigQuery Scheduled Queries**, also for the following reasons:

1. **Ease of Use:** Setting up scheduled queries in BigQuery is straightforward and quick.
2. **Cost-Effective:** Utilizes the free tier and credits efficiently.
3. **Simplicity:** No need for additional infrastructure or complex configurations.
4. **Serverless:** Fully managed by GCP, reducing the operational overhead.


### Implementation steps overview

1. Set up Terraform (provider.tf, versions.tf, variables.tf, terraform.tfvars, …)
2. Create BigQuery dataset and table, including schema
3. Create Service Account to run the jobs, and give it required permissions
4. Create Scheduled Query to Load data into temporary / helper table
5. Create Scheduled Query to Transform and Upsert data to final table
* Note: all steps prepared as Terraform code, and deployed via TF
* Note 2: this assumes input file is stored in an already existing Cloud Storage Bucket (if not, then of course that has to be done as well)


## Solution / code on Github

* [https://github.com/JoeSham/sentinelone](https://github.com/JoeSham/sentinelone)