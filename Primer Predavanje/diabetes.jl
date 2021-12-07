# load diabetes.data

using LinearAlgebra
using CSV
using DataFrames
using Plots

Diabete_Data = CSV.read("diabetes.csv",DataFrame)

n,d = size(Diabete_Data)
d = d-1

#println(Diabete_Data)

# compute the optimal theta

X = zeros(n,d)
y = zeros(n,1)

for i=1:d
    X[:,i] = Diabete_Data[:,i]
end
#X = [ones(n,1)  X[:,3]]
X = [ones(n,1) X]
y = Diabete_Data[:,end]

theta_opt = X\y

# achieved loss
MSE = norm(X*theta_opt-y,2)^2/n

println("theta_opt: ", theta_opt)
println("RMSE: ",sqrt(MSE))

# plot
figure()
plot(y,y,"k")
plot(y,X*theta_opt,"o",alpha=0.4)
xlabel(L"$y$")
ylabel(L"predicted $y$")
title("prediction accuracy")
axis("square")
grid("on")

figure()
hist(y-X*theta_opt, bins=10, density=true)
title("prediction error")
grid("on")

# put JHK data into your predictor

#age
#sex
#bmi
#map	   mean arterial pressure				
#s1  tc :   total cholesterol
#s2  ldl    low density lipoprotein
#s3  hdl    high density lipoprotein
#s4  tch
#s5  ltg
#s6  glu
#        age  sex  bmi    map   tc     ldl    hdl     tch   ltg   glu
X_JHK = [41   1    18.3   90    171    80.0   74.9    2     4.75  90.0]
X_JHK = [1 X_JHK]

y_JHK = X_JHK*theta_opt

# plot


figure()
plot(y,y,"k")
plot(y,X*theta_opt,"o",alpha=0.4)
plot(y_JHK,y_JHK,"ro",alpha=0.4)
xlabel(L"$y$")
ylabel(L"predicted $y$")
axis("square")
grid("on")