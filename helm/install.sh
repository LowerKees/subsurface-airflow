# Check if all required utilities are available on the system
# If a required utility is not available, make sure to install it.
helm version
minikube version
kubectl version # For now: ignore any warnings raised by the exceeding of supported minor version skew of 1

minikube start --cpus=2 --memory=2g --kubernetes-version=1.20.15

# Check that the current context is set to minikube
context=$(kubectl config current-context)

if [[ $context -ne "minikube" ]]
then
    echo "context is not set to minikube"
    exit 1
else
    echo "context is set to $context"
fi

# Create namespace and local storage making it possible to mount
kubectl create namespace airflow 2>/dev/null # Redirecting STDERR if namespace already exists
kubectl apply -f helm/airflow-dags-pvc.yml
kubectl apply -f helm/airflow-dags-pv.yml

echo "Enter database user"
read dbUser

echo "Enter database password"
read dbPass

echo "Enter database host"
read dbHost

echo "Enter fernet key"
read fernetKey

# Start by adding the helm repo for the latest stable airflow chart
helm repo add apache-airflow https://airflow.apache.org
helm upgrade --install airflow apache-airflow/airflow \
    -f helm/values.yml \
    --namespace airflow \
    --create-namespace \
    --set data.metadataConnection.pass=$dbPass \
    --set data.metadataConnection.host=$dbHost \
    --set data.metadataConnection.user=$dbUser\
    --set postgresql.postgresqlPassword=$dbPass \
    --set postgresql.postgresqlUsername=$dbUser \
    --set fernetKey=$fernetKey

# Import the namespace into the current context
kubectl config set-context --current --namespace airflow

# Log in to the web application
minikube service --url airflow-webserver -n airflow

# Use `minikube ssh` to
# open a terminal to the cluster node.
# Navigate to '/mnt/dags'.
# Copy the content from the dag.py file and paste it in /mnt/dags/dag.py
# This dir on the node should be mounted via the pv to the /opt/airflow/dags
# directory inside your pods.