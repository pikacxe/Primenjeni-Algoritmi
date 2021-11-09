mutable struct Graph
    adjMatrix:: Array{Int64,2}
    pheromoneMatrix:: Array{Float64,2}
    foodIndex:: Int64
    nodesCount :: Int64
end


function generateGraph(nodeCount:: Int64, adjMatrix:: Array{Int64,2}, foodIndex::Int64)
    pheromoneMatrix = ones(Float64,nodeCount,nodeCount)
    graph = Graph(adjMatrix,pheromoneMatrix,foodIndex,nodeCount)
    return graph
end


