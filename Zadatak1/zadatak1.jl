include("geneticAlgorithm.jl")
genesLength = 6
populationSize = 50
crossoverPoint = 3
mutationPercentage = 0.2
elitePercentage = 0.2
repeatSize = 3

population = generatePopulation(populationSize, genesLength)
calculatePopulationFitness!(population)
printPopulation(population)
popGen, repeatNum, population = geneticAlgorithm!(population, elitePercentage, crossoverPoint, mutationPercentage, repeatSize)
printPopulation(population)
print("Ukupan broj generacija je $popGen \n")
print("Broj ponavljanja poslednjeg najboljeg finess-a je $repeatNum \n")

