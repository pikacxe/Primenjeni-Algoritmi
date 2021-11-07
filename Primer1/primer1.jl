include("geneticAlgorithm.jl")

genesLength = 20
populationSize = 20
fitValue = 19

repeatSize = 3
selectSize = 5
crossoverPoint = 4
mutationPercentage = 0.2

population = generatePopulation(populationSize,genesLength)
calcuatePopulationFitness!(population,fitValue)
printPopulation(population)


popGen, repeatCounter, population = geneticAlgorithm(population,fitValue,
                                                repeatSize,selectSize,
                                                crossoverPoint,mutationPercentage)

printPopulation(population)
print("Ukupan broj generacija: $(popGen)\n")
print("Ukupan broj ponavljanja: $(repeatCounter)\n")