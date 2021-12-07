using DataFrames
using CSV
using Lathe.preprocess:TrainTestSplit
using GLM
using StatsBase
using StatsModels
using ROC
using Plots

data = DataFrame(CSV.File("tacke1000a.csv"))

dataTrain, dataTest = TrainTestSplit(data,.80)


fm = @formula(boja ~ x + y)

logisticRegeressor = glm(fm,dataTrain, Binomial(), ProbitLink())


dataPredictBoja = predict(logisticRegeressor, dataTest)

dataPredictTestClass = zeros(length(dataPredictBoja))

for i in 1:length(dataPredictBoja)
    if dataPredictBoja[i] < 0.5
        dataPredictTestClass[i] = 0;
    else
        dataPredictTestClass[i] = 1;
    end
end 


FPtest = 0
FNtest = 0
TPtest = 0
TNtest = 0

for i in 1:length(dataPredictTestClass)
    if dataTest.boja[i] == 0 && dataPredictTestClass[i] == 0
        global TNtest +=1
    elseif dataTest.boja[i] == 1 && dataPredictTestClass[i] == 1
        global TPtest +=1
    elseif dataTest.boja[i] == 1 && dataPredictTestClass[i] == 0
        global FNtest +=1
    elseif dataTest.boja[i] == 0 && dataPredictTestClass[i] == 1
        global FPtest +=1
    end
end



accuracyTest = (TPtest + TNtest) / (TPtest + TNtest + FPtest + FNtest)

sensitivity = TPtest / (TPtest + FNtest)

specificity = TNtest / (TNtest + FPtest)

println("TP = $TPtest, FP = $FPtest, TN = $TNtest, FN = $FNtest")
println("accuracy = $accuracyTest\n sensitivity = $sensitivity\n specificity = $specificity\n")


rocTest = ROC.roc(dataPredictBoja, dataTest.boja, true)

aucTest = AUC(rocTest)

if aucTest > 0.9
    println("Klasifikator je jako dobar!")
elseif aucTest > 0.8
    println("Klasifikator je veoma dobar!")
elseif  aucTest > 0.7
    println("Klasifikator je dosta dobar!")
elseif aucTest > 0.5
    println("Klasifikator je relativno dobar!")
else
    println("Klasifikator je los!")
end


#plot(rocTest, label="ROC")