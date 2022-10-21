using CSV
using DataFrames
using StatsBase

df = DataFrame(CSV.File("Car_Tyres_Dataset.csv"))

#display(describe(df))
#display(countmap(df[!, :Rating]))

df[ismissing.(df[!, :Rating]), :Rating] .= mean(skipmissing(df[!, :Rating])) 

#display(countmap(df[!, :Rating]))

CSV.write("train.csv",df)




