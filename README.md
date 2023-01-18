# Dbt Modelling Sample
This repo contains some examples of Dbt project and instructions of how to run it on GCP.

## Dbt setup
To use Dbt in the CloudShell / local environment, please follow the steps.

### Installation
```bash
pip install --user --upgrade dbt-core dbt-bigquery
echo "export PATH=$(python -m site --user-base)/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
dbt --version
```

### Testing Locally
Run Dbt locally
```bash
dbt --profiles-dir .dbt run
```

### Run in CloudRun
```bash
# set the project
gcloud config set project whejna-modelling-sandbox

# set the services
gcloud services enable artifactregistry.googleapis.com cloudbuild.googleapis.com datacatalog.googleapis.com datalineage.googleapis.com run.googleapis.com

# create repo in artifact registry
gcloud config set artifacts/location europe-west4
gcloud artifacts repositories create dbt-modelling-demo --repository-format=docker

# build the local image, tag it and push it to the arfifact registry
docker build --tag dbt-demo .
docker tag dbt-demo europe-docker.pkg.dev/whejna-modelling-sandbox/dbt-modelling-demo/dbt-on-cloud-run-demo
gcloud auth configure-docker europe-docker.pkg.dev
docker push europe-docker.pkg.dev/whejna-modelling-sandbox/dbt-modelling-demo/dbt-on-cloud-run-demo
gcloud artifacts docker images list europe-docker.pkg.dev/whejna-modelling-sandbox/dbt-modelling-demo/dbt-on-cloud-run-demo --include-tags

# create cloud run job
gcloud beta run jobs create dbt-demo --image europe-docker.pkg.dev/whejna-modelling-sandbox/dbt-modelling-demo/dbt-on-cloud-run-demo --region europe-west4 --command dbt --args='--profiles-dir' --args='.dbt' --args='run'

# run cloud run job
gcloud beta run jobs execute dbt-demo --region europe-west4
```

## See Also
Some notebooks to be re-used: https://github.com/hejnal/data-xform-samples