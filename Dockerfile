# Repository link: https://github.com/Mathias-Kozman/transitous

# Base image Debian
FROM debian:bookworm-slim

# Variables
ARG MOTIS_VERSION=v2.7.0

# Update and install dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        git \
        python3 \
        python3-pip \
        wget \
        bzip2 \
        rsync \
        openssh-client && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Configure Python and install libraries
RUN rm -f /usr/lib/python3.*/EXTERNALLY-MANAGED && \
    pip3 install --no-cache-dir \
        requests \
        ruamel.yaml \
        pycountry \
        beautifulsoup4 \
        lxml \
        license-expression

# Install MOTIS (routing engine)
RUN mkdir -p /opt/motis/ && \
    wget -qO - https://github.com/motis-project/motis/releases/download/${MOTIS_VERSION}/motis-linux-amd64.tar.bz2 | tar -C /opt/motis/ -jx

# Add MOTIS to PATH
ENV PATH=/opt/motis:$PATH

# Create working directory
WORKDIR /app

# Copy project files
COPY . .

# Expose port 8080
EXPOSE 8080

# Command to start the application
CMD ["/bin/bash"]
