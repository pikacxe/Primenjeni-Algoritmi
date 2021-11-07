include("entity.jl")


function generatePopulation(n, genesLength)
    data = []
    for i in 1:n
        entity = generateEntity(genesLength)
        push!(data,entity)
    end
    return data
end

function calculatePopulationFitness!(data, fitValue)
    for i in 1:length(data)
        calculateFitness!(data[i],fitValue)
    end
    sort!(data, by = d -> d.fitness, rev = false)
end

function printPopulation(data)
    for i in 1:length(data)
        printEntity(data[i])
    end
end


function selectPopulation(data,n)
    return copy(data[1:n])
end

function crossoverPopulation(data,crossoverPoint)
    newData = []
    for i in 1:length(data)
        for j in 1:length(data)
            entity1 = deepcopy(data[i])
            entity2 = deepcopy(data[j])
            crossover!(entity1,entity2,crossoverPoint)
            push!(newData,entity1)
            push!(newData,entity2) 
        end 
    end
    return newData
end

function mutatePopulation!(data, mutatePercentage)
    for i in 1:length(data) 
        mutate!(data[i],mutatePercentage)
    end
end