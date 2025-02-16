# Use the standard Python 3.9 image (non-slim)
FROM python:3.9

# Install necessary dependencies, including BLAST+ and any additional tools
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    wget \
    ncbi-blast+ \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install primerJinn from the remote PyPI source
RUN pip install --upgrade pip && \
    pip install primerJinn

# Optionally, create directories for input and output data
RUN mkdir -p /data/inputs /data/outputs

# Set the entrypoint.
# This assumes that installing the package creates an executable "primerJinn" in PATH.
ENTRYPOINT ["primerJinn"]

# If no arguments are provided, display the help message.
CMD ["--help"]
