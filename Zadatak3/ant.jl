mutable struct Ant
    route:: Array{Int64,1}
    currentIndexNode:: Int64
    fitness:: Int64
end

function generateAntPopulation(antCount::Int64,antsStartNode::Int64)
    ants = []
    for i in 1:antCount
        push!(ants,Ant([],antsStartNode,0))
    end
    return ants
end
