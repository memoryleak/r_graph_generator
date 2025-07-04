#!/usr/bin/env Rscript

# R Script: calculate_avg_shortest_path.R
# Description: Loads a GraphML file and calculates the average shortest path length between nodes.
# If native GraphML support is unavailable, parses via xml2.
# Usage: Rscript calculate_avg_shortest_path.R <graphml_file>

# ---------------------------
# Dependencies
# ---------------------------
if (!require("igraph", quietly = TRUE)) {
  install.packages("igraph", repos = "https://cloud.r-project.org")
  library(igraph)
}
if (!require("xml2", quietly = TRUE)) {
  install.packages("xml2", repos = "https://cloud.r-project.org")
  library(xml2)
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
# Attempt native GraphML support
g <- tryCatch({
  read_graph(graphml_file, format = "graphml")
}, error = function(e) {
  cat("Warning: native GraphML support unavailable, parsing manually with xml2...\n")
  doc <- read_xml(graphml_file)
  # Find edges in GraphML namespace
  ns <- xml_ns_rename(xml_ns(doc), d1 = xml_ns(doc)[[1]])
  edges <- xml_find_all(doc, ".//d1:edge", ns)
  edgelist <- do.call(rbind, lapply(edges, function(x) {
    c(xml_attr(x, "source"), xml_attr(x, "target"))
  }))
  graph_from_edgelist(edgelist, directed = FALSE)
})

# ---------------------------
# Calculate Average Shortest Path
# ---------------------------
# Treat graph as undirected; unconnected pairs allowed
avg_length <- mean_distance(g, directed = FALSE, unconnected = TRUE)

# ---------------------------
# Output Result
# ---------------------------
cat(sprintf("Average shortest path length: %.4f\n", avg_length))
