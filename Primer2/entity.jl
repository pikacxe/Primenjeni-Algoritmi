mutable struct Entity
    genes:: Array{Float64,1}
    fitness:: Float64
end


function generateEntity(genesLength)
    return Entity(rand(-1:0.001:1,genesLength), 0)
end


function calculateFitness!(entity)
    rez = 4*(entity.genes[1]^2) - 6*entity.genes[1] - 3*(entity.genes[2]^3)
    + 0.5*entity.genes[2] + 3*entity.genes[3] + 8*entity.genes[4] - 6.1*entity.genes[5] 
    + 2*entity.genes[6] - 10
    entity.fitness = abs(rez)
end



function printEntity(entity)
    for i in 1:length(entity.genes)
        print("$(entity.genes[i]) ")
    end
    print(" $(entity.fitness) \n");
end

function crossover!(entity1,entity2,crossoverPoint)
    for i in 1:crossoverPoint
        x = entity1.genes[i]
        entity1.genes[i] = entity2.genes[i]
        entity2.genes[i] = x
    end
end

function mutate!(entity,mutatePercentage)
    if rand(Float64) < mutatePercentage
        mutationPoint = rand(1:genesLength)
        entity.genes[mutationPoint] = 1 - entity.genes[mutationPoint]
    end
end
