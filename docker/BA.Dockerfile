FROM r-base:latest

# Install system dependencies and R packages
RUN R -e "install.packages('igraph', repos='https://cloud.r-project.org')"

# Create app directory
WORKDIR /app

# Copy the BA graph script into the container
COPY scripts/generate_ba_graph.R /app/generate_ba_graph.R
RUN chmod +x /app/generate_ba_graph.R

# Create output directory
RUN mkdir -p /app/data/graphs/ba

# Default command: run help
ENTRYPOINT ["Rscript", "/app/generate_ba_graph.R"]
CMD ["--help"]
