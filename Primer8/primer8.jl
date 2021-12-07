using DataFrames
using CSV
using MLBase
using StatsModels
using StatsBase
using GLM

data = DataFrame(CSV.File("tacke40c.csv"))

fm = @formula(y ~ x)

k = 5

averageAbsMeanErrorTest = 0.0
subData = collect(Kfold(length(data.x), k))

for i in 1:k
    dataTrain = data[subData[i],:]
    dataTest = data[setdiff(1:end, subData[i]),:]

    linearRegressor = lm(fm, dataTest)
    dataPredictTest = predict(linearRegressor, dataTest)

    errorTest = dataTest.y - dataPredictTest
    absMeanErrorTest = mean(abs.(errorTest))
    println("Prosecna greska [$i]: $absMeanErrorTest")
    global averageAbsMeanErrorTest += absMeanErrorTest
end


averageAbsMeanErrorTest /= k

println("Prosecna absolutna greska je: $averageAbsMeanErrorTest")
