#!/usr/bin/env Rscript

# R Script: generate_ws_graph.R
# Description: Generates multiple Watts–Strogatz small-world graphs with configurable parameters.
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
if (length(args) != 4) {
  cat("Usage: Rscript generate_ws_graph.R <num_nodes> <neighborhood_size> <rewiring_prob> <num_graphs>\n")
  quit(status = 1)
}

num_nodes         <- as.integer(args[1])
neighborhood_size <- as.integer(args[2])
rewiring_prob     <- as.numeric(args[3])
num_graphs        <- as.integer(args[4])

# Validate inputs
if (is.na(num_nodes) || num_nodes <= 0) {
  stop("Error: <num_nodes> must be a positive integer.")
}
if (is.na(neighborhood_size) || neighborhood_size <= 0 || neighborhood_size >= num_nodes/2) {
  stop("Error: <neighborhood_size> must be a positive integer less than num_nodes/2.")
}
if (is.na(rewiring_prob) || rewiring_prob < 0 || rewiring_prob > 1) {
  stop("Error: <rewiring_prob> must be a number between 0 and 1.")
}
if (is.na(num_graphs) || num_graphs <= 0) {
  stop("Error: <num_graphs> must be a positive integer.")
}

# ---------------------------
# Prepare output directory
# ---------------------------
output_dir <- "/app/data/graphs"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# ---------------------------
# Generate and Save Graphs
# ---------------------------
for (i in seq_len(num_graphs)) {
  # Output current graph index
  cat(sprintf("Working on graph %d\n", i))

  # Generate Watts–Strogatz graph: dimension=1 ring lattice rewired with prob
  g <- sample_smallworld(dim = 1, size = num_nodes,
                          nei = neighborhood_size, p = rewiring_prob)

  # Filenames
  png_file     <- file.path(output_dir, sprintf("ws_graph_n%d_k%d_p%s_%d.png",
                                                  num_nodes, neighborhood_size,
                                                  gsub("\\.", "", as.character(rewiring_prob)), i))
  graphml_file <- file.path(output_dir, sprintf("ws_graph_n%d_k%d_p%s_%d.graphml",
                                                  num_nodes, neighborhood_size,
                                                  gsub("\\.", "", as.character(rewiring_prob)), i))

  # Save PNG
  png(filename = png_file, width = 800, height = 800)
  plot(g,
       vertex.size  = 5,
       vertex.label = NA,
       main         = sprintf("Watts–Strogatz WS(n=%d, k=%d, p=%.2f) #%d",
                              num_nodes, neighborhood_size, rewiring_prob, i)
  )
  dev.off()

  # Save GraphML
  write_graph(g, file = graphml_file, format = "graphml")
}
