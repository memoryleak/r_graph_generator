FROM memoryleak/r:4.5.1


# Copy the BA graph script into the container
COPY scripts/generate_ws_graph.R /app/generate_ws_graph.R
RUN chmod +x /app/generate_ws_graph.R

# Default command: run help
ENTRYPOINT ["Rscript", "/app/generate_ws_graph.R"]
CMD ["--help"]
