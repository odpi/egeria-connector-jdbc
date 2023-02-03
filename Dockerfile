# SPDX-License-Identifier: Apache-2.0
# Copyright Contributors to the Egeria project

# This is the EGERIA version - typically passed from the ci/cd pipeline
ARG EGERIA_BASE_IMAGE=quay.io/odpi/egeria:latest
# Must be set to help get the right files for the connextors

FROM ${EGERIA_BASE_IMAGE}
ARG VERSION

# Labels from https://github.com/opencontainers/image-spec/blob/master/annotations.md#pre-defined-annotation-keys (with additions prefixed    ext)
# We should inherit all the base labels from the egeria image and only overwrite what is necessary.
LABEL org.opencontainers.image.description = "Egeria with JDBC connector" \
      org.opencontainers.image.documentation = "https://github.com/odpi/egeria-connector-jdbc"

# This assumes we only have one uber jar (ensure old versions cleaned out beforehand). Avoids having to pass connector version

# Note that we currently only build a simple jar. If additional dependencies are needed, a jar with dependencies will be needed, or the libraries will need to be added here
ENV VERSION ${VERSION}

COPY jdbc-resource-connector/build/libs/egeria-connector-resource-jdbc-${VERSION}.jar /deployments/server/lib
COPY jdbc-integration-connector/build/libs/egeria-connector-integration-jdbc-${VERSION}.jar /deployments/server/lib

# Add any additional, openly-licensable, connectors here - ensure licenses are added to the LICENSE-Docker.txt
COPY LICENSE-Docker.txt /deployments/server/LICENSE-JDBC-3RD-PARTY.txt

# We need extra permissions to RUN this command at build time
USER root
RUN (cd /deployments/server/lib && curl -O -J https://jdbc.postgresql.org/download/postgresql-42.5.2.jar)

# Restore the standard id for container execution
USER jboss
