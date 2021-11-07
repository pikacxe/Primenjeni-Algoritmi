mutable struct Entity
    genes:: Array{Int64,1}
    fitness:: Int64
end


function generateEntity(genesLength)
    return Entity(rand(0:1,genesLength),0)
end


function calculateFitness!(entity,values, weights, maxCapacity)
    selectedWeigths = weights[entity.genes .== 1]
    sumSelectedWeights = sum(selectedWeigths)
    if sumSelectedWeights > maxCapacity
        entity.fitness = sum(selectedWeigths)
    else
        notSelectedValues = values[entity.genes .==0]
        entity.fitness = sum(notSelectedValues)
    end
end



function printEntity(entity)
    for i in 1:length(entity.genes)
        print("$(entity.genes[i])")
    end
    print(" $(entity.fitness) \n");
end

function crossover!(entity1,entity2,crossoverPoint1,crossoverPoint2)
    for i in crossoverPoint1:crossoverPoint2
        x = entity1.genes[i]
        entity1.genes[i] = entity2.genes[i]
        entity2.genes[i] = x
    end

end

function mutate!(entity,mutatePercentage)
    if rand(Int64)< mutatePercentage
        mutationPoint = rand(1:genesLength)
        entity.genes[mutationPoint] = 1 - entity.genes[mutationPoint]
    end
end