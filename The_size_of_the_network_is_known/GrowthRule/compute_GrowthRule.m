function [optimalFit] = compute_GrowthRule(N)

    bestD = zeros(1, 4);
    bestFit = zeros(ceil(exp(1)*N), 4); 
    bestrsquare = zeros(1, 4);
    bestrmse = zeros(1, 4);
    bestgamma = zeros(1, 4);
    bestmissing = zeros(1, 4);


    [bestD(1), bestFit(:, 1), bestrsquare(1), bestrmse(1), bestgamma(1), bestmissing(1)] = WeigthSigmoidRegression(N, 100);
    [bestD(2), bestFit(:, 2), bestrsquare(2), bestrmse(2), bestgamma(2), bestmissing(2)] = WeigthPowerRegression(N, 100);
    [bestD(3), bestFit(:, 3), bestrsquare(3), bestrmse(3), bestgamma(3), bestmissing(3)] = WeigthLinearRegression(N, 100);
    [bestD(4), bestFit(:, 4), bestrsquare(4), bestrmse(4), bestgamma(4), bestmissing(4)] = WeigthExponentialRegression(N, 100);    
    
    [D, pos] = min(bestD);    

    finalD = bestD(pos);
    optimalFit = bestFit(:, pos);
    finalRMSE = bestrmse(pos);
    finalGamma = bestgamma(pos);
    
    str = sprintf('GrowthRule/OptimalFit_%d', N);
    save(str, 'finalD', 'optimalFit', 'finalRMSE', 'finalGamma');
   
    
