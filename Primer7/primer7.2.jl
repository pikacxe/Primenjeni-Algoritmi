using DataFrames
using CSV
using Lathe.preprocess:TrainTestSplit
using GLM
using StatsBase
using StatsModels
using ROC
using Plots

data = DataFrame(CSV.File("pacijenti1000a.csv"))

dataTrain, dataTest = TrainTestSplit(data, .80)

fm = @formula(bolest ~ visina + tezina + dbp + sbp)

logisticRegressor = glm(fm, dataTrain, Binomial(), ProbitLink())

dataPredictTest = predict(logisticRegressor, dataTest)

dataPredictTestClass = zeros(length(dataPredictTest))

for i in 1:length(dataPredictBoja)
    if dataPredictTest[i] < 0.5
        dataPredictTestClass[i] = 0
    else
        dataPredictTestClass[i] = 1
    end
end 


brojObolelihOdDijabetesaPredict = sum(dataPredictTestClass)
brojObolelihOdDijabetesa = sum(dataTest.bolest)

brojZdravihPredict = length(dataPredictTestClass) - brojObolelihOdDijabetesaPredict
brojZdravih = length(data.bolest) - brojObolelihOdDijabetesa

println("Predvidjen broj obolelih: $brojObolelihOdDijabetesaPredict")
println("Broj osoba koje imaju dijabetes: $brojObolelihOdDijabetesa")

println("Predvidjen broj zdravih: $brojZdravihPredict")
println("Broj zdravih osoba: $brojZdravih")