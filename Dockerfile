# Use a non-slim Python image as an example
FROM python:3.9

# Install necessary dependencies (e.g., BLAST+ if needed)
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    wget \
    ncbi-blast+ \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install primerJinn and xlsxwriter from PyPI
RUN pip install --upgrade pip && \
    pip install primerJinn xlsxwriter

# Optionally, create directories for input and output data
RUN mkdir -p /data/inputs /data/outputs

# Set the entrypoint.
ENTRYPOINT ["PCRinSilico"]

# Default command displays help if no arguments provided.
CMD ["--help"]
