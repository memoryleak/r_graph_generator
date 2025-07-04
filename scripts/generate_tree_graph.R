#!/usr/bin/env Rscript

# R Script: generate_tree_graph.R
# Description: Generates multiple random tree graphs (uniform spanning trees) with configurable parameters.
# Only outputs the current graph index as it works.

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
if (length(args) != 2) {
  cat("Usage: Rscript generate_tree_graph.R <num_nodes> <num_graphs>\n")
  quit(status = 1)
}

num_nodes  <- as.integer(args[1])
num_graphs <- as.integer(args[2])

# Validate inputs
if (is.na(num_nodes) || num_nodes <= 1) {
  stop("Error: <num_nodes> must be an integer greater than 1.")
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
  cat(sprintf("Working on tree graph %d\n", i))

  # Generate a random tree (uniform spanning tree) with sample_tree
  g <- sample_tree(n = num_nodes, directed = FALSE)

  # Filenames
  png_file     <- file.path(output_dir, sprintf("tree_graph_n%d_%d.png", num_nodes, i))
  graphml_file <- file.path(output_dir, sprintf("tree_graph_n%d_%d.graphml", num_nodes, i))

  # Save PNG
  png(filename = png_file, width = 800, height = 800)
  plot(
    g,
    vertex.size  = 5,
    vertex.label = NA,
    main         = sprintf("Random Tree (n=%d) #%d", num_nodes, i)
  )
  dev.off()

  # Save GraphML
  write_graph(g, file = graphml_file, format = "graphml")
}
