include("population.jl")



function geneticAlgorithm(data, repeatSize, selectSize, crossoverPoint, mutationPercentage)
    calculatePopulationFitness!(data)
    bestFit = data[1].fitness
    reapeatCounter = 1
    popGen = 0

    while (bestFit > 0 && reapeatCounter <= repeatSize)
        data = selectPopulation(data, selectSize)
        data = crossoverPopulation(data,crossoverPoint)
        mutatePopulation!(data,mutationPercentage)
        calculatePopulationFitness!(data)

        if bestFit == data[1].fitness
            reapeatCounter +=1
        
        else 
            bestFit = data[1].fitness 
            reapeatCounter = 1
        end
        popGen +=1
    end
    return popGen, reapeatCounter, data
end