include("swarm.jl")


function PsoAlgorithm(swarm, targetValue, maxIteration)
    globalBestParticle = swarm[1];
    globalBestParticle = calculateGlobalBestParticle(swarm,targetValue,globalBestParticle);
    for i in 1:maxIteration
        if globalBestParticle.currentValue == targetValue
            printSwarm(swarm)
            println("SOLUTION : ");
            printParticle(globalBestParticle);
            println("Solution found after $i iteration");
            return

        end
        updateSwarmVelocity!(swarm,globalBestParticle,targetValue);
        updateSwarmPosition!(swarm,targetValue);
        globalBestParticle = calculateGlobalBestParticle(swarm,targetValue,globalBestParticle);
    end
    printSwarm(swarm);
    print("GLOBAL SOLUTION : ");
    printParticle(globalBestParticle);
end


function calculateGlobalBestParticle(swarm,targetValue, globalBestParticle)
    for i in 1:length(swarm)
        if abs(swarm[i].currentValue - targetValue) < abs(globalBestParticle.currentValue - targetValue)
            globalBestParticle = deepcopy(swarm[i]);
        end
    end
    return globalBestParticle;
end