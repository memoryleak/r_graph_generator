FROM memoryleak/r:4.5.1

# Copy the BA graph script into the container
COPY scripts/generate_ba_graph.R /app/generate_ba_graph.R
RUN chmod +x /app/generate_ba_graph.R

# Default command: run help
ENTRYPOINT ["Rscript", "/app/generate_ba_graph.R"]
CMD ["--help"]
