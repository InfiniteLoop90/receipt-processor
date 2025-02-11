# Note! As of 2023-03-14 at least, using alpine images for the building or packaging stages don't work on
# Apple Silicon architecture since they depend on some arm64-only thing, e.g. the output was:
#    Sending build context to Docker daemon  202.2kB
#    Step 1/8 : FROM maven:3.9.0-eclipse-temurin-17-alpine AS build
#    3.9.0-eclipse-temurin-17-alpine: Pulling from library/maven
#    no matching manifest for linux/arm64/v8 in the manifest list entries

#
# Build stage
#
FROM maven:3.9-eclipse-temurin-21 AS build
# Do OS package updates first
RUN apt-get --assume-yes update && apt-get --assume-yes upgrade \
    && apt-get clean \
    && rm --recursive --force /var/lib/apt/lists/*
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn --file /home/app/pom.xml clean package

#
# Package stage
#
FROM eclipse-temurin:21-jdk
# Do OS package updates first
RUN apt-get --assume-yes update && apt-get --assume-yes upgrade \
    && apt-get clean \
    && rm --recursive --force /var/lib/apt/lists/*
# Copy the jar
COPY --from=build /home/app/target/receipt-processor.jar /usr/local/lib/app.jar
# Create the lower privileged user
ARG USERNAME=nonroot
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --no-log-init --uid ${USER_UID} --gid ${USER_GID} --create-home ${USERNAME}
# Switch to the lower privileged user
USER ${USERNAME}
# Expose the necessary port(s) and start it
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/app.jar"]
