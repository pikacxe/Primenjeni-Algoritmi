include("algorithm.jl");


numberOfParticle = 10;
numberOfOperands = 3;
minRang = 100;
maxRang = 200;
targetValue = 100;
maxIteration = 2000
maxVelocity = 10


swarm = generateSwarm(numberOfParticle,numberOfOperands,minRang,maxRang);
PsoAlgorithm(swarm,targetValue,maxIteration);