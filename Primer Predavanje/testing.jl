

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




function getSelectedColumns(selectedColumns,X)
    localX = []
    if selectedColumns != 0
        for i in selectedColumns
            push!(localX,X[:,i])
        end
        return localX
    else 
        return 0
    end
end


X = [1 2 3 4 5;
     1 2 3 4 5;
     1 2 3 4 5;
     1 2 3 4 5]


d = 10

for i in 1:d-1
    for j in 1:d
        temp = getIndexes(i,j,d)
        println(temp == 0 ? "" : temp)
    end
end