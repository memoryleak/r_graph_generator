FROM memoryleak/r:4.5.1

# Copy the BA graph script into the container
COPY scripts/generate_tree_graph.R /app/generate_tree_graph.R
RUN chmod +x /app/generate_tree_graph.R

# Default command: run help
ENTRYPOINT ["Rscript", "/app/generate_tree_graph.R"]
CMD ["--help"]
