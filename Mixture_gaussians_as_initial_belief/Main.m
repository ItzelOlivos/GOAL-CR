% --- Important note: use  addpath(genpath(<path to all subfolders>)) before
% --- the execution of this script

addpath(genpath('PerfectInformation'))
addpath(genpath('GrowthRule'))
addpath(genpath('GOAL-CR'))
addpath(genpath('FixedOptimalProbability'))
addpath(genpath('ContinuousGOAL-CR'))

% -----------------------------------------------------------------------
% ----------------------------- Parameters ------------------------------
distance_between_means = [10, 20, 40, 80, 160, 320, 400, 450, 900];

sigma = 800;
proportion_gaussian_1 = 3;
proportion_gaussian_2 = 1;

sims = 1000;
span = 1000;

mu1 = ceil(span/2) - distance_between_means/2;
mu2 = ceil(span/2) + distance_between_means/2;

% --- For each network of size N, will compute and simulate access policies ---
for i = 1:length(mu1)
    m1 = mu1(i);
    m2 = mu2(i);

    compute_GOALCR(span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2)
    compute_ContinuousGOALCR(span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2)
    compute_GrowthRule(span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2, sims);

    simulate_GOALCR(span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2, sims)
    simulate_ContinuousGOALCR(span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2, sims)
    str = sprintf('GrowthRule/OptimalFit_%d_%d_%d_%d_%d_%d', span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2);
    load(str);        
    simulate_GrowthRule(bestFit, span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2, sims, true);                
    simulate_FixedOptimal(span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2, sims)
    simulate_PerfectInformation(span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2, sims)

    formatSpec = 'Simulations for %d and %d is done';
    str = sprintf(formatSpec, m1, m2)    
end     

% --------------------------- Plot results ------------------------------
plot_results(span, distance_between_means, sigma, proportion_gaussian_1, proportion_gaussian_2)