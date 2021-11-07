include("geneticAlgorithm.jl")

genesLength = 6
populationSize = 10

repeatSize = 3
selectSize = 3
crossoverPoint = 4
mutationPercentage = 0.2

population = generatePopulation(populationSize,genesLength)
calculatePopulationFitness!(population)
printPopulation(population)


popGen, repeatCounter, population = geneticAlgorithm(population,
                                                repeatSize,selectSize,
                                                crossoverPoint,mutationPercentage)

printPopulation(population)
print("Ukupan broj generacija: $(popGen)\n")
print("Ukupan broj ponavljanja: $(repeatCounter)\n")