>**Important**: the files in this repository help to show some possible issues with Apache Airflow. They are in NO WAY production ready. They will create an insecure and unstable deployment.

# Directory Structure

## Airflow

Contains Airflow DAG definition files.

## Helm

- Contains values file for helm chart. 
- Contains instructions to configure helm to use the Airflow chart.

## Bring Your Own Database

- This helm chart assumes you bring your own database.
- The database can be hosted in the cloud or on any network available to your cluster.