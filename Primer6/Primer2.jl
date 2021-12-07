using Statistics
using StatsModels
using GLM
using DataFrames
using CSV
using Lathe

data = DataFrame(CSV.File("automobili.csv"))
data = Lathe.preprocess.predict(data, :model)
dataTrain, dataTest = Lathe.preprocess.TrainTestSplit(data,.80)
fm = @formula(cena ~ kubikaza+godiste+model)
linearRegressor = lm(fm, dataTrain)

predvidjenaCena = predict(linearRegressor, dataTest)
println("Procenjene cene vozila: ")
for i in 1:length(predvidjenaCena)
   println("X$i: $(dataTest.proizvodjac[i])  $(dataTest.model[i]) $(dataTest.kubikaza[i]) $(dataTest.godiste[i]) Cena: $(dataTest.cena[i]) Procena: $(predvidjenaCena[i])")
end

# Procena greske 
# Racunanje i ispis gresaka
errorsTest = dataTest.cena-predvidjenaCena
println()
println("Spisak svih gresaka pri testiranju je: $(round.(abs.(errorsTest); digits = 2))")
# Racunanje i ispis proseka greske
absMeanErrorTest = mean(abs.(errorsTest))
println("Prosecna absolutna greska pri testiranju je: $absMeanErrorTest evra")
# Racunanje prosecne relativne greske u procentima MAPE
mapeTest = mean(abs.(errorsTest./dataTest.cena))
println("Prosecna relativna greska pri testiranju je: $(mapeTest*100) procenata")