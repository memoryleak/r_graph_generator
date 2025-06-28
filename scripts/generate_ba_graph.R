#!/usr/bin/env Rscript

# R Script: generate_ba_graph.R
# Description: Generates multiple Barabási–Albert (BA) preferential attachment graphs with configurable parameters.
# Only outputs the current graph index as it works.

# ---------------------------
# Dependencies
# ---------------------------
if (!require("igraph", quietly = TRUE)) {
  install.packages("igraph", repos = "http://cran.r-project.org")
  library(igraph)
}

# ---------------------------
# Parse Command-line Arguments
# ---------------------------
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3) {
  cat("Usage: Rscript generate_ba_graph.R <num_nodes> <edges_per_step> <num_graphs>\n")
  quit(status = 1)
}

num_nodes      <- as.integer(args[1])
edges_per_step <- as.integer(args[2])
num_graphs     <- as.integer(args[3])

if (is.na(num_nodes) || num_nodes <= 1) {
  stop("Error: <num_nodes> must be an integer greater than 1.")
}
if (is.na(edges_per_step) || edges_per_step <= 0 || edges_per_step >= num_nodes) {
  stop("Error: <edges_per_step> must be a positive integer less than <num_nodes>.")
}
if (is.na(num_graphs) || num_graphs <= 0) {
  stop("Error: <num_graphs> must be a positive integer.")
}

# ---------------------------
# Prepare output directory
# ---------------------------
output_dir <- "/app/data/graphs/ba"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# ---------------------------
# Generate and Save Graphs
# ---------------------------
for (i in seq_len(num_graphs)) {
  # Output current graph index
  cat(sprintf("Working on graph %d\n", i))

  # Generate BA graph
  g <- sample_pa(n = num_nodes, power = 1, m = edges_per_step, directed = FALSE)

  # Filenames
  png_file     <- file.path(output_dir, sprintf("ba_graph_n%d_m%d_%d.png", num_nodes, edges_per_step, i))
  graphml_file <- file.path(output_dir, sprintf("ba_graph_n%d_m%d_%d.graphml", num_nodes, edges_per_step, i))

  # Save PNG
  png(filename = png_file, width = 800, height = 800)
  plot(
    g,
    vertex.size  = 5,
    vertex.label = NA,
    main         = sprintf("Barabási–Albert BA(n=%d, m=%d) #%d", num_nodes, edges_per_step, i)
  )
  dev.off()

  # Save GraphML
  write_graph(g, file = graphml_file, format = "graphml")
}
