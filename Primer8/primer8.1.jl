using CSV
using DataFrames
using StatsBase
using StatsModels
using Statistics
using Lathe
using GLM

data = DataFrame(CSV.File("motor_cena.csv"))


#display(describe(data))
#display(countmap(data[!,:Boja]))
#display(countmap(data[!,:Stanje]))
#display(countmap(data[!,:Ostecenje]))
#display(describe(data))

select!(data, Not(:Boja))

data[ismissing.(data[!,:Stanje]), :Stanje] .= mode(skipmissing(data[!,:Stanje]))
data[ismissing.(data[!,:Ostecenje]), :Ostecenje] .= mode(skipmissing(data[!,:Ostecenje]))
data[ismissing.(data[!,:Kilometraza]), :Kilometraza] .= trunc(Int64, mode(skipmissing(data[!,:Kilometraza])))
dropmissing!(data,[:Cena])
filter!(row -> row.Cena != 0, data)

filter!(row -> row.Kilometraza <= 500000, data)
filter!(row -> row.Godiste <= 2021 && row.Godiste >= 1900, data)
filter!(row -> row.BrojCilindara > 0 && row.BrojCilindara < 200, data)

covKwKs = cov(data.kW, data.KS)

if covKwKs > 0.6
    select!(data, Not(:kW))
end

fm = @formula(Cena ~ Stanje+Tip+Godiste+Kilometraza+Kubikaza+KS+BrojCilindara+Ostecenje)
dataTrain, dataTest = Lathe.preprocess.TrainTestSplit(data, .75)
linearRegressor = lm(fm, dataTrain)

predictTest = predict(linearRegressor, dataTest)
errorTest = dataTest.Cena - predictTest
rmseTest = sqrt(mean(errorTest.*errorTest))

predictTrain = predict(linearRegressor, dataTrain)
errorTrain = dataTrain.Cena - predictTrain
rmseTrain = sqrt(mean(errorTrain.*errorTrain))

println("RMSE trening skupa je $rmseTrain")
println("RMSE test skupa je: $rmseTest")

if r2(linearRegressor) > 0.5
    println("Model je dobar za predvidjanje!")
end



#plotlyjs()

#plotGodisteCena = scatter(data.Godiste, data.Cena, title = "Godiste - Cena", xlabel="Godiste", ylabel = "Cena")

#display(plotGodisteCena)
#savefig(plotGodisteCena, "godisteCena.html")

#plotKilometrazaCena = scatter(data.Kilometraza, data.Cena, title = "Kilometraza - Cena", xlabel="Kilometraza", ylabel = "Cena")

#display(plotKilometrazaCena)
#savefig(plotKilometrazaCena, "kilometrazaCena.html")

