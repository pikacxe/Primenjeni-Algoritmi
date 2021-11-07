include("population.jl")


function coverage(bestFits)
    len = length(bestFits)
    if bestFits[len] == 0
        return true
    elseif len < 3
        return false
    else 
        return bestFits[len-1] == bestFits[len]
    end
end


function geneticAlgorithm(data, crossoverPoint1,crossoverPoint2,values,weights,maxCapacity, mutationPercentage,elitePercentage)
    calculatePopulationFitness!(data,values,weights,maxCapacity)
    populationSize = length(data)
    eliteSize = Int(trunc(elitePercentage*populationSize))
    eliteSize = eliteSize + (populationSize - eliteSize)%2
    bestFits = [data[1].fitness]
    while !coverage(bestFits)
        elite = deepcopy(selectPopulation(data,eliteSize))
        data = selectPopulation(data, populationSize-eliteSize)
        data = crossoverPopulation(data,crossoverPoint1,crossoverPoint2)
        mutatePopulation!(data,mutationPercentage)
        data = [data;elite]
        calculatePopulationFitness!(data,values,weights,maxCapacity)
        bestFits = [bestFits;data[1].fitness]
    end
    return length(bestFits), data
end