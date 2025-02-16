# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Disable interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages for building PrimerJinn
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Clone the PrimerJinn repository
# (Replace the URL with the correct one if needed)
RUN git clone https://github.com/SemiQuant/primerJinn.git /opt/primerJinn

# Build PrimerJinn
WORKDIR /opt/primerJinn
RUN mkdir build && cd build && cmake .. && make

# Optionally, you can create directories for input and output if your workflow requires it.
RUN mkdir -p /data/inputs /data/outputs

# Add the build directory to PATH so the binary is easily accessible
ENV PATH="/opt/primerJinn/build:${PATH}"

# Set the entrypoint to the PrimerJinn binary. Adjust the binary name if it differs.
ENTRYPOINT ["/opt/primerJinn/build/primerJinn"]

# If no command-line arguments are provided, display the help message.
CMD ["--help"]
