% -----------------------------------------------------------------------
% ----------------------------- Parameters ------------------------------
distance_between_means = [10, 20, 40, 80, 160, 320, 400, 450, 900];

sigma = 800;
proportion_gaussian_1 = 3;
proportion_gaussian_2 = 1;

Simulations = 1000;
span = 1000;

mu1 = ceil(span/2) - distance_between_means/2;
mu2 = ceil(span/2) + distance_between_means/2;

% % ---------------------- Compute greedy polices -------------------------
% for i = 1:length(mu1)
%     m1 = mu1(i);
%     m2 = mu2(i);
%     compute_policies(span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2)
%     str = sprintf('Computing policies')             
% end    
% % ---------------------- Compute growth rule polices --------------------
% for i = 1:length(mu1)
%     m1 = mu1(i);
%     m2 = mu2(i);    
%     str = sprintf('Greedy_policies_vMixture/OptimalPolicy_%d_%d_%d_%d_%d_%d', span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2);
%     load(str);  
%     createFit(span, policy, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2)                       
% end    
% % --------------------------- Simulate protocols ------------------------
% for i = 1:length(mu1)
%     m1 = mu1(i);
%     m2 = mu2(i);
%     Sims_Opt(span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2, Simulations)
%     Sims_Greedy(span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2, Simulations)
%     Sims_Fixed(span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2, Simulations)
%     Sims_Rule(span, m1, m2, sigma, proportion_gaussian_1, proportion_gaussian_2, Simulations)        
%     str = sprintf('Simulations completed')
% end
% --------------------------- Plot results ------------------------------
plot_results(span, distance_between_means, sigma, proportion_gaussian_1, proportion_gaussian_2)