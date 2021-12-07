using LinearAlgebra
using CSV
using DataFrames

# selecting the index combination from given range
function getIndexes(i,j,d)
    if i == j
        return [i]
    elseif i > j && i > 2
        return 0
    else
        niz1 = []
        niz2 = collect(i:j-1)
        for k in 1:d
            if !(k in niz2)
                push!(niz1,k)
            end
        end
        return length(niz1) == 0 ? 0 : niz1
    end
end

#selecting columns from indexes as matrix
function getSelectedColumns(selectedColumns,X)
    if selectedColumns != 0
        localX = ones(size(X)[1],1)
        for i in selectedColumns
            localX = [localX X[:,i]]
        end
        return localX
    else 
        return 0
    end
end

#load data
Diabete_Data = CSV.read("diabetes.data",DataFrame)

n,d = size(Diabete_Data)
d = d-1

# compute the optimal theta

X = zeros(n,d)
y = zeros(n,1)

for i=1:d
    X[:,i] = Diabete_Data[:,i]
end

y = Diabete_Data[:,end]

# for storing MSEs
savedMSE = []

#for  storing top contender colums
savedIndexes = []

#  age 
#  sex 
#  bmi 
#  map	   mean arterial pressure	
#  s1  tc :   total cholesterol 
#  s2  ldl    low density lipoprotein 
#  s3  hdl    high density lipoprotein 
#  s4  tch 
#  s5  ltg 
#  s6  glu

# string representation of said colums
nameByIndex = ["AGE" "SEX" "BMI" "MAP" "TC" "LDL" "HDL" "TCH" "LTG" "GLU"]


#Calculating all possible solutions
for i in 1:d-1
    for j in 1:d
        localX = []
        temp = getIndexes(i,j,d)
        selectedColumns = temp == 0 ? continue : temp
        localX = getSelectedColumns(selectedColumns,X)
        localX = localX == 0 ? continue : localX
        theta_opt = localX\y
        # achieved loss
        MSE = norm(localX*theta_opt-y,2)^2/n
        push!(savedMSE,MSE)
        push!(savedIndexes,selectedColumns)
    end
end

# Number of top results
numOfBests = 10


#Finding top results
for i in 1:numOfBests
   bestIndex = argmin(savedMSE)
    bestMSE = savedMSE[bestIndex]
    leastColums = savedIndexes[bestIndex]
    println("\n [$i] BEST SOLUTION")
    println("Best MSE of: $(bestMSE) with ")
    for j in leastColums
        println("$(nameByIndex[j]) ") 
    end
    println("parameters as most impactful")
    deleteat!(savedMSE,bestIndex)
    deleteat!(savedIndexes,bestIndex)
end

