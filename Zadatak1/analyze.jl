include("geneticAlgorithm.jl")
genesLength = 6
populationSize = 50
crossoverPoint = 3
mutationPercentage = 0.2
elitePercentage = 0.2
repeatSize = 3

population = generatePopulation(populationSize, genesLength)
calculatePopulationFitness!(population)
print("-------------------------Pocetna populacija--------------------\n")
printPopulation(population)
print("---------------------------------------------------------------\n")

function testElite(startValue,endValue)
    for elitePercentage in startValue:0.01:endValue

        print("\n-----------------------------------------------------\n")    
        geneticAlgorithm!(population, elitePercentage, crossoverPoint, mutationPercentage, repeatSize)
        print("\n-----------------------------------------------------\n")
    end
end

function testMutation(startValue,endValue)
    for mutationPercentage in startValue:0.01:endValue
        print("\n-----------------------------------------------------\n")    
        geneticAlgorithm!(population, elitePercentage, crossoverPoint, mutationPercentage, repeatSize)
        print("\n-----------------------------------------------------\n")
    end  
end

function testCrossover(startValue,endValue)
    for crossoverPoint in startValue:endValue
        print("\n-----------------------------------------------------\n")    
        geneticAlgorithm!(population, elitePercentage, crossoverPoint, mutationPercentage, repeatSize)
        print("\n-----------------------------------------------------\n")
    end 
    
end

#testElite(0,0.3)
#testMutation(0,0.3)
testCrossover(2,5)