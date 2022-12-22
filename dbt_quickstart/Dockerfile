FROM python:3.8.5

# Install required system packages and cleanup to reduce image size
RUN apt-get update -y && \
  apt-get install --no-install-recommends -y -q \
  git libpq-dev python-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install data build tool
RUN pip install -U pip
RUN pip install dbt-bigquery

# Set working directory
ENV DBT_DIR /dbt/
WORKDIR $DBT_DIR

# Copy files to the image
COPY . $DBT_DIR

# Run dbt
ENTRYPOINT ["dbt"]

