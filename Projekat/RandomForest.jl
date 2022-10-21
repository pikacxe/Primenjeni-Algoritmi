using CSV
using DataFrames
using Lathe.models: RandomForestClassifier
using Lathe.preprocess: TrainTestSplit
using ROC
using StatsBase
using Statistics
using Lathe.stats
using Random

dfTrain = DataFrame(CSV.File("train.csv"))
dfTest = DataFrame(CSV.File("test.csv"))

dataTrain, dataTest = TrainTestSplit(dfTrain, .80)

feature = :Size

# Parametri Random Forest Algoritma
NumberOfTrees  = collect(1:2:2000)
MaxDepth = 5
MinNumberOfLeaves = 2


globalBestDepth = 0
globalBestAUC = 0
for i in NumberOfTrees
    trainY = Array(dataTrain[!, :Type])
    trainX = Array(dataTest[!, feature])
    testY = Array(dataTest[!, :Type])
    testX = Array(dataTest[!, feature])

    #trainX = Array(dfTrain)
    #testX = Array(dfTest)

    RandomForestModel = RandomForestClassifier(trainX, trainY, n_trees = i, min_node_records = MinNumberOfLeaves, max_depth = MaxDepth)
    dataPredicted = RandomForestModel.predict(testX)

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

    acc = (TP + FN) / (TP + TN + FP + FN)
    sensitivity = TP / (TP + FN)
    specificity = TN / (TN + FP)
    #println("TP = $TP\nTN = $TN\nFP = $FP\nFN = $FN")
    #println(" Accuracy: $acc \n Sensitivity: $sensitivity\n Specificity: $specificity")

    rocTest = ROC.roc(dataPredicted, testY, true)
    aucTest = AUC(rocTest)
    println("Test[$i] Povrsina ispod krive u procentima je: $aucTest")

    #if (aucTest>0.9)
    #    println("Klasifikator je jako dobar")
    #elseif (aucTest>0.8)
    #    println("Klasifikator je veoma dobar")
    #elseif (aucTest>0.7)
    #    println("Klasifikator je dosta dobar")
    #elseif (aucTest>0.5)
    #    println("Klasifikator je relativno dobar")
    #else
    #    println("Klasifikator je los")
    #end

    if globalBestAUC < aucTest
        global globalBestAUC = aucTest
        global globalBestDepth = i
    end
end



println("Najbolje postignut AUC: $globalBestAUC za dubinu: $globalBestDepth\n")




