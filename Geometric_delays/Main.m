% --- Important note 1: 
% --- To execute this code, you first need to execute
% --- The_size_of_the_network_is_known/Main script

% --- Important note 2: use  addpath(genpath(<path to all subfolders>)) before
% --- the execution of this script

addpath(genpath('PerfectInformation'))
addpath(genpath('GrowthRule'))
addpath(genpath('GOAL-CR'))
addpath(genpath('FixedOptimalProbability'))
addpath(genpath('ContinuousGOAL-CR'))

% -----------------------------------------------------------------------
% ----------------------------- Parameters ------------------------------
Nodes = [40, 80]; %80, 160, 320, 640, 1000, 2000, 3000];
phi = [0.001, 0.005, 0.2];
Simulations = 10;
% --------------------------- Simulate protocols ------------------------
for idx = 1:length(Nodes)
    N = Nodes(idx);        
    for i = 1:length(phi)
        p = phi(i);
        
        simulate_GOALCR(N, p, Simulations)
        
        simulate_ContinuousGOALCR(N, p, Simulations)        
        
        simulate_GrowthRule(N, p, Simulations)
        
        simulate_FixedOptimal(N, p, Simulations)
        
        simulate_PerfectInformation(N, p, Simulations)
        
        formatSpec = 'Completed for %d nodes with var of survival %.2f';
        str = sprintf(formatSpec, N, p)            
    end    
end 
% --------------------------- Plot Results ------------------------------
plot_results(Nodes, phi)