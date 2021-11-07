mutable struct Particle
    values :: Array{Int64,1}
    currentValue :: Int64
    velocity :: Array{Float64,1}
    bestValues :: Array{Int64,1}
    bestValue :: Int64
end

function updateValue!(particle)
    sum = 0;
    for i in 1:length(particle.values)
        sum += particle.values[i];
    
    end
    particle.currentValue = sum;
end



function generateParticle(numberOfOperands,minRang,maxRang)
    particle = Particle(rand(minRang:maxRang,numberOfOperands),0,
                        fill(0.0, numberOfOperands),fill(0,numberOfOperands),0);
    updateValue!(particle);
    particle.bestValues = copy(particle.values);
    particle.bestValue = particle.currentValue;
    return particle;
end


function printParticle(particle)
    for i in 1:length(particle.values)
        if i < length(particle.values)
            print(particle.values[i], "+");
        else
            print(particle.values[i], "=");
        end
    end
    print(particle.currentValue,"\n");
end


# Cv = 1 Cp = 2 Cg = 2
function updateVelocity!(particle, globalBestParticle, maxVelocity)
    for i in 1:length(particle.velocity)
        particle.velocity[i] += 2.0*rand(0:1)*(particle.bestValues[i] - particle.values[i]) + 
                                2.0*rand(0:1)*(globalBestParticle.values[i] - particle.values[i]);
        if particle.velocity[i] > maxVelocity
            particle.velocity[i] = maxVelocity;
        elseif particle.velocity[i] <  -maxVelocity
            particle.velocity[i] = -maxVelocity;
        end
    end
end

function updatePosition!(particle, targetValue)
    for i in 1:length(particle.values)
        particle.values[i] += trunc(Int64,particle.velocity[i]);
    end
    updateValue!(particle);
    if abs(particle.currentValue - targetValue) < abs(particle.bestValue - targetValue)
        particle.bestValues = copy(particle.bestValues);
        particle.bestValue = particle.currentValue;
    end
end