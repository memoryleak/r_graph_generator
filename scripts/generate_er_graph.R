#!/usr/bin/env Rscript

# R Script: generate_er_graph.R
# Description: Generates multiple Erdős–Rényi (G(n, p)) random graphs with configurable parameters.
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
  cat("Usage: Rscript generate_er_graph.R <num_nodes> <edge_probability> <num_graphs>\n")
  quit(status = 1)
}

num_nodes  <- as.integer(args[1])
edge_prob  <- as.numeric(args[2])
num_graphs <- as.integer(args[3])

# Validate inputs
if (is.na(num_nodes) || num_nodes <= 0) {
  stop("Error: <num_nodes> must be a positive integer.")
}
if (is.na(edge_prob) || edge_prob < 0 || edge_prob > 1) {
  stop("Error: <edge_probability> must be a number between 0 and 1.")
}
if (is.na(num_graphs) || num_graphs <= 0) {
  stop("Error: <num_graphs> must be a positive integer.")
}

# Clean probability string for filenames
prob_str <- gsub("\\.", "", as.character(edge_prob))

# ---------------------------
# Prepare output directory
# ---------------------------
output_dir <- "/app/data/graphs/er"
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# ---------------------------
# Generate and Save Graphs
# ---------------------------
for (i in seq_len(num_graphs)) {
  # Output current graph index
  cat(sprintf("Working on graph %d\n", i))

  # Generate Erdős–Rényi graph G(n, p)
  g <- sample_gnp(n = num_nodes, p = edge_prob, directed = FALSE, loops = FALSE)

  # Filenames
  png_file     <- file.path(output_dir, sprintf("er_graph_n%d_p%s_%d.png", num_nodes, prob_str, i))
  graphml_file <- file.path(output_dir, sprintf("er_graph_n%d_p%s_%d.graphml", num_nodes, prob_str, i))

  # Save PNG
  png(filename = png_file, width = 800, height = 800)
  plot(
    g,
    vertex.size  = 5,
    vertex.label = NA,
    main         = sprintf("Erd\u0151s–R\u00e9nyi G(%d, %s) #%d", num_nodes, edge_prob, i)
  )
  dev.off()

  # Save GraphML
  write_graph(g, file = graphml_file, format = "graphml")
}
