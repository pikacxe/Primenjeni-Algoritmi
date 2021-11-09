include("algorithm.jl")

graphNodes = 3
adjMatrix = [-1 50 100; 50 -1 60; 100 60 -1]
foodNode = 3
maxIteration = 200
antsCounts = 20
pheromoneExponent = 1
desirabilityExponent = 0.1
pheromoneDepositFactor = 1
evaporationRate = 0.1

graph = generateGraph(graphNodes,adjMatrix,foodNode)


bestPath, bestFitness, graph = algorithmAntColonyOptimization(graph, maxIteration, antsCounts, pheromoneExponent,
                                            desirabilityExponent, pheromoneDepositFactor, evaporationRate)


print("Best solution $(bestPath) with length $(bestFitness)")