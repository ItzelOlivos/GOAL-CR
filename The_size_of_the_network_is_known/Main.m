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
sims = 1000;

% --- For each network of size N, will compute and simulate access policies ---
for idx = 1:length(Nodes)
    N = Nodes(idx);

    compute_GOALCR(N)
    compute_ContinuousGOALCR(N)
    compute_GrowthRule(N);
    tau = compute_FixedOptimal(N);
 
    simulate_GOALCR(N, sims)
    simulate_ContinuousGOALCR(N, sims)

    str = sprintf('GrowthRule/OptimalFit_%d', N);
    load(str);
    simulate_GrowthRule(N, optimalFit, sims)
    
    simulate_FixedOptimal(N, tau, sims)
    
    simulate_PerfectInformation(N, sims)

    formatSpec = 'Simulations for %d nodes is done';
    str = sprintf(formatSpec, N)
end
% --------------------------- Plot Results -----------------------------

plot_results(Nodes)
