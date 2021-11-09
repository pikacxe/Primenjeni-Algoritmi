using Pkg
#Pkg.add("StatsBase")
using StatsBase

include("ant.jl")
include("graph.jl")

function algorithmAntColonyOptimization(graph::Graph, maxIteration:: Int64,antsCount:: Int64, pheromoneExponent::Int64, desirableExponent::Float64, pheromoneDepositFactor::Int64, evaporationRate:: Float64) 
    
    bestFitness = Inf
    bestPath = []
    
    for i in 1:maxIteration
        ants = generateAntPopulation(antsCount,1)
        for j in 1:antsCount
            antReachDestination = false
            while (!antReachDestination)
                # trazimo mogucu putanju
                possiblePaths = findPossiblePaths(ants[j],graph)
                # racunamo verovatnocu
                probabilities = calculateProbabilities(graph, ants[j], possiblePaths, pheromoneExponent, desirableExponent)
                # biramo putanju
                chosenNode = sample(possiblePaths,Weights(probabilities))
                # pomeramo mrava
                push!(ants[j].route,ants[j].currentIndexNode)
                ants[j].currentIndexNode = chosenNode 
                if chosenNode == graph.foodIndex
                    antReachDestination = true
                    push!(ants[j].route, ants[j].currentIndexNode)
                end
            end
            # trazenje najboljeg resenja za iteraciju
            fitness = calculateFitness(ants[j],graph)
            ants[j].fitness = fitness
            if fitness < bestFitness
                bestFitness = fitness
                bestPath = deepcopy(ants[j].route)
            end
        end
        # update feromona
        updatePheromones!(ants,graph, pheromoneDepositFactor, evaporationRate)
    end
    return bestPath, bestFitness, graph
end


function findPossiblePaths(ant:: Ant,graph:: Graph)
    possiblePaths = findall(graph.adjMatrix[ant.currentIndexNode,:].!= -1)
    if !isempty(ant.route)
        possiblePaths = deleteat!(possiblePaths,findall(possiblePaths.== ant.route[end]))
    end
    return possiblePaths
end

function calculateProbabilities(graph::Graph, ant::Ant, possiblePaths::Array{Int64,1}, pheromoneExponent, desirableExponent)
    pathSum = 0
    for possibleNode in possiblePaths
        pathSum += ((graph.pheromoneMatrix[ant.currentIndexNode, possibleNode])^pheromoneExponent) * 
                    ((graph.adjMatrix[ant.currentIndexNode,possibleNode])^desirableExponent)
    end

    probabilities = Float64[]

    for possibleNode in possiblePaths
        probability = ((graph.pheromoneMatrix[ant.currentIndexNode, possibleNode]) ^ pheromoneExponent) * 
        ((graph.adjMatrix[ant.currentIndexNode,possibleNode]) ^ desirableExponent) / pathSum

        push!(probabilities,probability)
    end
    return probabilities
end


function calculateFitness(ant::Ant,graph::Graph)
    pathLength = 0
    for i in 1:(length(ant.route)-1)
        pathLength += graph.adjMatrix[ant.route[i],ant.route[i+1]]
    end
    return pathLength
end

function updatePheromones!(ants, graph, pheromoneDepositFactor, evaporationRate)
    pheromoneDepositMatrix = zeros(Float64, graph.nodesCount, graph.nodesCount)

    for currentAnt in ants
        route = currentAnt.route
        for j in length(route)-1
            pheromoneDepositMatrix[route[j],route[j+1]] += pheromoneDepositFactor / currentAnt.fitness
        end
    end

    for i in 1:graph.nodesCount
        for j in 1:graph.nodesCount
           pheromone = graph.pheromoneMatrix[i,j]
           graph.pheromoneMatrix[i,j] = (1 - evaporationRate) * pheromone + pheromoneDepositMatrix[i,j]
           pheromoneDepositMatrix[j,i] = graph.pheromoneMatrix[i,j]
        end
    end 
end

