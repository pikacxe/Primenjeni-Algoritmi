include("algorithm.jl")

graphNodes = 3
#              A  B   C   D    E
adjMatrix = [ -1  500 400 500 800; 
              500 -1  200 200 300;
              400 200 -1  300 500;
              500 200 300 -1  200;
              800 300 500 200 -1  ]
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