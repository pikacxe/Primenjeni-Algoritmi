include("geneticAlgorithm.jl")

genesLength = 30
populationSize = 50
crossoverPoint1 = 3
crossoverPoint2 = 8
repeatSize = 3
selectSize = 5
maxCapacity = 35

values = rand(1:100,genesLength)
weights = rand(1:10,genesLength)

mutationPercentage = 0.1
elitePercentage = 0.2

population = generatePopulation(populationSize,genesLength)
calculatePopulationFitness!(population,values,weights,maxCapacity)
printPopulation(population)


popGen, population = geneticAlgorithm(population,crossoverPoint1,crossoverPoint2,
                                      values,weights,maxCapacity,mutationPercentage,elitePercentage)

printPopulation(population)
print("Ukupan broj generacija: $(popGen)\n")
print("Tezine kamenja: \n$(weights)\n")
print("Vrednosti su: \n$(values)\n")


sumWeight = sum(weights[population[1].genes .==1])

print("Tezina kamenja je: $(sumWeight)\n")
if sumWeight > maxCapacity
    print("Nije pronadjeno resenje\n")
else
    print("Jedinka: $(population[1])")
end