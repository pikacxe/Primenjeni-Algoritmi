include("entity.jl")

function generatePopulation(n, genesLength)
   data = []
   for i in 1:n 
       entity1 = generateEntity(genesLength)
       push!(data, entity1)
   end
   return data
end

function printPopulation(data)
   for i in 1:length(data)
      printEntity(data[i])
   end
end

function calculatePopulationFitness!(data)
   for i in 1:length(data)
      calculateFitness!(data[i])
   end
   sort!(data, by = d -> d.fitness, rev=false)
end

function crossoverPopulation(data, crossoverPoint)
    newData = []
    for i in 1:2:length(data)
       entity1 = deepcopy(data[i])
       entity2 = deepcopy(data[i+1])
       crossover!(entity1, entity2, crossoverPoint)
       push!(newData, entity1)
       push!(newData, entity2)
    end
    return newData   
end

function mutatePopulation!(data, mutationPercentage) 
   for i in 1:length(data)
      mutate!(data[i], mutationPercentage)
   end;
end

function selectPopulation(data, n)
   return copy(data[1:n])
end
