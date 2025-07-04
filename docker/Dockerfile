FROM r-base:4.5.1
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    && apt clean -y \
    && rm -rf /var/lib/apt/lists/*
# Install system dependencies and R packages
RUN R -e "install.packages('igraph', repos='https://cloud.r-project.org')"
RUN R -e "install.packages('xml2', repos='https://cloud.r-project.org')"

# Create app directory
WORKDIR /app
