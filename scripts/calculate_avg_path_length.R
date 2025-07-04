#!/usr/bin/env Rscript

# R Script: calculate_avg_shortest_path.R
# Description: Loads a GraphML file and calculates the average shortest path length between nodes.
# Usage: Rscript calculate_avg_shortest_path.R <graphml_file>

# ---------------------------
# Dependencies
# ---------------------------
if (!require("igraph", quietly = TRUE)) {
  install.packages("igraph", repos = "https://cloud.r-project.org")
  library(igraph)
}

# ---------------------------
# Parse Command-line Arguments
# ---------------------------
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1) {
  cat("Usage: Rscript calculate_avg_shortest_path.R <graphml_file>\n")
  quit(status = 1)
}

graphml_file <- args[1]

if (!file.exists(graphml_file)) {
  stop(sprintf("Error: File '%s' does not exist.", graphml_file))
}

# ---------------------------
# Load Graph
# ---------------------------
cat(sprintf("Loading graph from '%s'...\n", graphml_file))
g <- read_graph(graphml_file, format = "graphml")

# ---------------------------
# Calculate Average Shortest Path
# ---------------------------
# For undirected analysis
avg_length <- average.path.length(g, directed = FALSE, unconnected = TRUE)

# ---------------------------
# Output Result
# ---------------------------
cat(sprintf("Average shortest path length: %.4f\n", avg_length))
