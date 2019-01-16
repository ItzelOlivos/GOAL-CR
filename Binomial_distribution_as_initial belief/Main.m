% --- Important note: use  addpath(genpath(<path to all subfolders>)) before
% --- the execution of this script

addpath(genpath('PerfectInformation'))
addpath(genpath('GrowthRule'))
addpath(genpath('GOAL-CR'))
addpath(genpath('FixedOptimalProbability'))
addpath(genpath('ContinuousGOAL-CR'))

% -----------------------------------------------------------------------------
% ----------------------- Input Parameters ------------------------------------
Nodes = [80, 160, 320, 640, 1000];
lambda = [0.5, 0.65, 0.8];
sims = 1000;

% --- For each network of size N, will compute and simulate access policies ---
for idx = 1:length(Nodes)
    N = Nodes(idx);
    for i = 1:length(lambda)
        p = lambda(i);
        
        compute_GOALCR(N, p)
        compute_ContinuousGOALCR(N, p)
        compute_GrowthRule(N, p, sims);
        
        simulate_GOALCR(N, p, sims)
        simulate_ContinuousGOALCR(N, p, sims)
        str = sprintf('GrowthRule/OptimalFit_%d_%d', N, p*1000);
        load(str);        
        simulate_GrowthRule(N, bestFit, p, sims, true);                
        simulate_FixedOptimal(N, p, sims)
        simulate_PerfectInformation(N, p, sims)

        formatSpec = 'Simulations for %d nodes is done';
        str = sprintf(formatSpec, N)
    end     
end
% --------------------------- Plot Results -----------------------------

plot_results(Nodes, lambda)