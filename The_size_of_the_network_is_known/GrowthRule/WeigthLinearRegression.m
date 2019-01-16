function [minD, bestFit, bestrsquare, bestrmse, bestgamma, bestmissing] = WeigthLinearRegression(N, execs)

    str = sprintf('GOAL-CR/OptimalPolicy_%d', N);
    load(str); 

    halt = ceil(exp(1)*N);
    policy = policy(1:halt);
    t = 0:length(policy)-1;

    incs = [0, 1, 2, 4, 8, 16, 32, 64, 100]/1000;
    gamma = 1 - incs;

    fits = cell(length(gamma), 1);
    rsquare = zeros(length(gamma), 1);
    rmse = zeros(length(gamma), 1);
    DCR = zeros(length(gamma), 1);
    missing = zeros(length(gamma), 1);
    
    for ptr = 1:length(gamma)
        w = gamma(ptr).^t;

        str = strcat('@(b,x) min(max(', num2str(1/N), ', b(1).*x + b(2)), 1)');
        fun = str2func(str);    
        start = [.001, 0.001];
        wnlm = fitnlm(t, policy, fun, start, 'Weight', w);
        rsquare(ptr) = wnlm.Rsquared.Ordinary;
        rmse(ptr) = wnlm.RMSE;
        fits{ptr} = wnlm;         

        fit_policy = predict(wnlm, [1:10*N]');
        stats = simulate_GrowthRule(N, fit_policy, execs);
        DCR(ptr) = stats(1);
        missing(ptr) = stats(3);
        
        strsave = sprintf('GrowthRule/Candidates/RuleLinear/Results_%d_%d', N, gamma(ptr)*1000);
        save(strsave,'stats', 'rsquare', 'rmse', 'fits');         
    end

    [minD, minDpos] = min(DCR);
    minD
    bestFit = predict(fits{minDpos}, t');   
    bestrsquare = rsquare(minDpos)
    bestrmse = rmse(minDpos)
    bestgamma = gamma(minDpos)
    bestmissing = missing(minDpos)
    
    str = ['Best at gamma = ' num2str(gamma(minDpos)) ' D = ' num2str(minD)];