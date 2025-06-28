FROM r-base:latest

# Install system dependencies and R packages
RUN R -e "install.packages('igraph', repos='https://cloud.r-project.org')"

# Create app directory
WORKDIR /app

# Copy the BA graph script into the container
COPY scripts/generate_er_graph.R /app/generate_er_graph.R
RUN chmod +x /app/generate_er_graph.R

# Create output directory
RUN mkdir -p /app/data/graphs/er

# Default command: run help
ENTRYPOINT ["Rscript", "/app/generate_er_graph.R"]
CMD ["--help"]
