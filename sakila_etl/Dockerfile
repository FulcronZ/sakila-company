# This stage exports dependencies from poetry into requirements.txt
# XXX: Use non-slim image because it requires curl to download poetry
FROM python:3.10 AS build

# Install poetry dependency manager
RUN curl -sSL https://install.python-poetry.org | python3 -

RUN mkdir -p /opt/dagster
WORKDIR /opt/dagster
COPY pyproject.toml poetry.lock /opt/dagster/
RUN /root/.local/bin/poetry export -f requirements.txt --without-hashes --output requirements.txt

# This stage installs dependencies and copy project files for running
FROM python:3.10-slim AS runner

ENV DAGSTER_HOME=/opt/dagster

# Install dependencies using pip
COPY --from=build /opt/dagster/requirements.txt /opt/dagster/
RUN pip install -r /opt/dagster/requirements.txt

# Copy Dagster project files
COPY dagster.yaml /opt/dagster/
COPY workspace.yaml /opt/dagster/
COPY sakila_etl/ /opt/dagster/sakila_etl/

WORKDIR /opt/dagster
EXPOSE 3000
ENTRYPOINT ["dagster", "dev", "-h", "0.0.0.0", "-p", "3000", "-w", "workspace.yaml"]
