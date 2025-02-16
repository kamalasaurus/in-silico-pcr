# Use Ubuntu 20.04 as a base image
FROM ubuntu:20.04

# Disable interactive prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install Primer3 (primer3_core) and any needed utilities
RUN apt-get update && \
    apt-get install -y primer3 && \
    rm -rf /var/lib/apt/lists/*

# Create directories for input and output data
RUN mkdir -p /data/inputs /data/outputs

# Set the working directory to /data
WORKDIR /data

# Optionally verify that primer3_core is available
RUN command -v primer3_core

# Set the entrypoint so that the container acts as a primer3_core executable.
ENTRYPOINT ["primer3_core"]

# If no arguments are provided, simply run primer3_core without arguments.
CMD []
