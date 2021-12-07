using StatsModels
using GLM
using DataFrames
using CSV
using Lathe.preprocess: TrainTestSplit
using Plots
using Statistics

# 1. Priprema i provera podataka
# Ucitavanje podataka
data = DataFrame(CSV.File("tacke10.csv"))
# Napomena, testirati i za fajlove tacke40.csv, tacke40a.csv, 
# tacke40b.csv, tacke40c.csv, tacke40d.csv i tacke40e.csv,
c =  cor(data.x, data.y)
println("Koeficijent korelacije je: $c")
if c>0.9
   println("Postoji veoma jaka veza izmedju podataka")
elseif c>0.7
   println("Postoji jaka veza izmedju podataka ")
elseif c>0.5
   println("Postoji umerena veza izmedju podataka ")
else
   println("Veza izmedju podataka nije dovoljno jaka")
end
      
# Podela na skup za obuku i testiranja
dataTrain, dataTest = TrainTestSplit(data,.80)
# Prikaz ulaznih podataka
# Prikaz opisa podataka
# Za prikaz strukture podataka, odkomentarisati sledeci red
# describe(data)
# Prikaz podataka u obliku grafikona
myInputPlot = scatter(dataTrain.x,dataTrain.y, title = "Tacke, pre linearne regresije", ylabel = "Y values", xlabel = "X value")
scatter!(myInputPlot, dataTest.x, dataTest.y)

# 2. Linearna regresija
# Priprema za linearnu regresiju sa skupom za obuku
fm = @formula(y ~ x)
linearRegressor = lm(fm, dataTrain)
# Testranje podataka linearnom regresijom
dataPredictedTrain = predict(linearRegressor, dataTrain)
dataPredictedTest = predict(linearRegressor, dataTest)

# Ispis podataka sa testiranja
for i in 1:length(dataPredictedTest)
   println("(X$i, Y$i) = ($(dataTest.x[i]), $(dataTest.y[i])) Predicted: Y$i $(dataPredictedTest[i])")
end
# Grafikon podataka sa testiranja
myOutputPlot = scatter(dataTrain.x, dataTrain.y, title = "Tacke, tacke posle linearne regresije", ylabel = "Y values", xlabel = "X value", legend=:bottomright)
scatter!(myOutputPlot, dataTest.x, dataTest.y)
scatter!(myOutputPlot, dataTest.x, dataPredictedTest)
scatter(myOutputPlot)
# 3. Analiza rezultata
# racunanje vrednosti r2 (R squared)
println()
rSquared = r2(linearRegressor)
println("Vrednost r squared iznosi $rSquared")
if (rSquared>0.9)
   println("Ovaj model je jako dobar za predvidjanje")
elseif (rSquared>0.7)
   println("Ovaj model je veoma dobar za predvidjanje")
elseif (rSquared>0.5)
   println("Ovaj model je relativno dobar za predvidjanje")
else 
   println("Ovaj model nije dobar za predvidjanje")
end

# Racunanje gresaka za skup za obuku
# Racunanje gresaka za svaku vrednost posebno
errorsTrain = dataTrain.y-dataPredictedTrain
println()
println("Spisak svih gresaka pri obuci je: $(round.(errorsTrain; digits = 3))")
# Racunanje proseka greske
absMeanErrorTrain = mean(abs.(errorsTrain))
# Racunanje prosecne relativne greske u procentima MAPE
mapeTrain = mean(abs.(errorsTrain./dataTrain.y))
# Racunanje kvadarata gresaka za svaku vrednost posebno
errorTrainSquared = errorsTrain.*errorsTrain
# Racunanje MSE i RMSE (Root Mean Square Error)
mseTrain = mean(errorTrainSquared)
rmseTrain = sqrt(mean(errorTrainSquared))

println("Prosecna absolutna greska pri obuci je: $absMeanErrorTrain")
println("Prosecna relativna greska pri obuci je: $mapeTrain")
println("Prosek kvadarata greske pri obuci je: $mseTrain")
println("Koren proseka kvadarata greske pri obuci je: $rmseTrain")

# Racunanje gresaka za test skup
# Racunanje gresaka za svaku vrednost posebno
errorsTest = dataTest.y-dataPredictedTest
println()
println("Spisak svih gresaka pri testiranju je: $(round.(errorsTest; digits = 3))")
# Racunanje proseka greske
absMeanErrorTest = mean(abs.(errorsTest))
# Racunanje prosecne relativne greske u procentima MAPE
mapeTest = mean(abs.(errorsTest./dataTest.y))
# Racunanje kvadarata gresaka za svaku vrednost posebno
errorTestSquared = errorsTest.*errorsTest
# Racunanje MSE i RMSE (Root Mean Square Error)
mseTest = mean(errorTestSquared)
rmseTest = sqrt(mean(errorTestSquared))

println("Prosecna absolutna greska pri testiranju je: $absMeanErrorTest")
println("Prosecna relativna greska pri testiranju je: $mapeTest")
println("Prosek kvadarata greske pri testiranju je: $mseTest")
println("Koren proseka kvadarata greske pri testiranju je: $rmseTest")

# Provera da li je sistem pogodan za testiranje
if (rmseTrain<rmseTest)
   println("Sistem je dobro istreniran")
else
   println("Sistem nije dobro istreniran")
end