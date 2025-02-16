# Use an Ubuntu base image
FROM ubuntu:20.04

# Disable interactive frontend during build
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools
RUN apt-get update && \
    apt-get install -y wget ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt

# Download the isPCR binary from UCSC (for linux.x86_64)
RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/isPcr && \
    chmod +x isPcr && \
    mv isPcr /usr/local/bin/

# Optionally, verify installation by displaying the usage message
RUN /usr/local/bin/isPcr -help

# Set the entrypoint to isPCR so that it runs when the container is executed.
ENTRYPOINT ["/usr/local/bin/isPcr"]

# By default, display help if no arguments are passed.
CMD ["-help"]
