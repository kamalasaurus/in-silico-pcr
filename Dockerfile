# Use Ubuntu 20.04 as a base image
FROM ubuntu:20.04

# Disable interactive prompts during package installs
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install Primer3 (primer3_core) and any needed utilities
RUN apt-get update && \
    apt-get install -y primer3 && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /data

# Verify installation (optional; you can remove this line later)
RUN command -v primer3_core

# Set the entrypoint so that the container acts as a primer3_core executable.
ENTRYPOINT ["primer3_core"]

# By default, if no arguments are provided, show the help message.
CMD ["--help"]
