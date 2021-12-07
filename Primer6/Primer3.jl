using StatsModels
using GLM
using DataFrames
using CSV
using Statistics
using MLBase

# 1. Priprema i provera podataka
# Ucitavanje podataka
data = DataFrame(CSV.File("tacke40c.csv"))
fm = @formula(y ~ x)

# Podesavanje KFold kros validacije
k = 5
a = collect(Kfold(length(data.x), k))
averageAbsMeanErrorTest = 0.0
for i in 1:k
    # Podela na skup za obuku i testiranja, i predvidjanje
    dataTrain = data[a[i], :]
    dataTest = data[setdiff(1:end, a[i]), :]
    linearRegressor = lm(fm, dataTrain)
    dataPredictedTest = predict(linearRegressor, dataTest)
    # Racunanje gresaka za skup za obuku
    errorsTest = dataTest.y-dataPredictedTest
    absMeanErrorTest = mean(abs.(errorsTest))
    # Racunanje MSE i RMSE (Root Mean Square Error)
    println("Prosecna absolutna greska za test $i je: $absMeanErrorTest")
    global averageAbsMeanErrorTest += absMeanErrorTest
end
averageAbsMeanErrorTest /= k
println("Prosecna absolutna greska za sva testiranja je: $averageAbsMeanErrorTest")
