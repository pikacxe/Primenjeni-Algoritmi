include("population.jl")



function geneticAlgorithm(data, fitValue, repeatSize, selectSize, crossoverPoint, mutationPercentage)
    calcuatePopulationFitness!(data, fitValue)
    bestFit = data[1].fitness
    reapeatCounter = 1
    popGen = 0

    while (bestFit > 0 && reapeatCounter <= repeatSize)
        data = selectPopulation(data, selectSize)
        data = crossoverPopulation(data,crossoverPoint)
        mutatePopulation!(data,mutationPercentage)
        calculatePopulationFitness!(data,fitValue)

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