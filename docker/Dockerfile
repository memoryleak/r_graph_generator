FROM r-base:4.5.1

# Install system dependencies and R packages
RUN R -e "install.packages('igraph', repos='https://cloud.r-project.org')"

# Create app directory
WORKDIR /app
