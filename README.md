# R graph generator
Collection of R-Scripts to generate different graph types.

## Prerequisites
### Docker (Recommended)
- Docker
- Docker Compose

## Usage
### Build base image
    docker build -t memoryleak/r:4.5.1 -f docker/Dockerfile .
    
### Using Docker compose

The easiest way to run the graph generators is using Docker:
    
    docker compose build
    docker compose up

## Graph Types

### Erdős-Rényi Graphs
Random graphs where each possible edge appears independently with probability *p*. 

### Barabási-Albert Graphs
Scale-free networks generated through preferential attachment, where new nodes connect to existing nodes with probability proportional to their degree.

### Watts–Strogatz small-world
Watts–Strogatz small-world graphs are a type of network model that captures key features of many real-world systems, such as social and biological networks. 

### Tree
Tree graphs are a type of connected, acyclic graph that resemble a branching structure similar to a tree in nature. In a tree graph, there is exactly one unique path between any pair of nodes, ensuring no cycles exist. 

## Development

### Adding New Graph Types

To add support for new graph types:

1. Create a new R script in the `scripts/` directory
2. Follow the naming convention: `generate_[type]_graph.R`
3. Add corresponding Dockerfile in the `docker/` directory
4. Update `docker-compose.yml` with the new service
5. Update this README with documentation

## License

This project is licensed under the terms specified in the LICENSE file.

## Dependencies

The R scripts may require the following packages, but should be handled by the containers:
- `igraph` - Graph creation and analysis
- Additional packages as specified in individual scripts