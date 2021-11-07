include("algorithm.jl");


numberOfParticle = 10;
numberOfOperands = 6;
minRang = -1;
maxRang = 1;
targetValue = 0;
maxIteration = 2000;
maxVelocity = 1;


swarm = generateSwarm(numberOfParticle,numberOfOperands,minRang,maxRang);
PsoAlgorithm(swarm,targetValue,maxIteration);