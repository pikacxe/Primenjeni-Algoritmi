using CSV
using DataFrames
using MLBase
using Lathe.models: RandomForestClassifier
using ROC

df = DataFrame(CSV.File("Car_Tyres_Dataset.csv"))
# Tube = 0, Tubeless = 1 , vrednost koriscena za klasfikaciju

feature = :LoadIndex

# Parametri Random Forest Algoritma
NumberOfTrees  = 100
MaxDepth = 3
MinNumberOfLeaves = 2

# Podesavanje KFold kros validacije
k = 3
a = collect(Kfold(length(df.Type), k))
bestAUC = 0
for i in 1:k
    # Podela na skup za obuku i testiranja, i predvidjanje
    dataTrain = df[a[i], :]
    dataTest = df[setdiff(1:end, a[i]), :]

    trainY = Array(dataTrain[!, :Type])
    trainX = Array(dataTest[!, feature])
    testY = Array(dataTest[!, :Type])
    testX = Array(dataTest[!, feature])

    # Random Forest Klasifikator
    RandomForestModel = RandomForestClassifier(trainX, trainY, n_trees = NumberOfTrees, min_node_records = MinNumberOfLeaves, max_depth = MaxDepth)
    dataPredicted = RandomForestModel.predict(testX)

    # Provera tacnosti modela
    TP = 0
    TN = 0
    FP = 0
    FN = 0
    for i in 1:length(dataPredicted)
        if dataPredicted[i] == 0 && testY[i] == 0
            TN += 1
        elseif dataPredicted[i] == 1 && testY[i] == 1
            TP += 1
        elseif dataPredicted[i] == 0 && testY[i] == 1
            FN += 1
        elseif dataPredicted[i] == 1 && testY[i] == 1
            FP += 1
        end
    end

    # accuracy (preciznost)
    acc = (TP + FN) / (TP + TN + FP + FN)
    # sensitivity (osetljivost, True positive rates)
    sensitivity = TP / (TP + FN)
    # specificity (specifičnost, True negative rates)
    specificity = TN / (TN + FP)
    println("------------------- TEST [$i] -----------------------")
    println("TP = $TP\nTN = $TN\nFP = $FP\nFN = $FN")
    println(" Accuracy: $acc \n Sensitivity: $sensitivity\n Specificity: $specificity")

    # Roc kriva
    rocTest = ROC.roc(dataPredicted, testY, true)
    aucTest = AUC(rocTest)
    println("Povrsina ispod krive u procentima je: $aucTest")

    if bestAUC < aucTest
        global bestAUC = aucTest
    end

    # Procena klasifikatora
    if (aucTest>0.9)
        println("Klasifikator je jako dobar")
    elseif (aucTest>0.8)
        println("Klasifikator je veoma dobar")
    elseif (aucTest>0.7)
        println("Klasifikator je dosta dobar")
    elseif (aucTest>0.5)
        println("Klasifikator je relativno dobar")
    else
        println("Klasifikator je los")
    end
    println("-----------------------------------------------------")
end

println("Najbolja postignuta AUC vrednost za $k testiranja: $bestAUC")


