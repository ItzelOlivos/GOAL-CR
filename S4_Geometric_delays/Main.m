% -----------------------------------------------------------------------
% ----------------------------- Parameters ------------------------------
Nodes = [10, 20, 40, 80, 160, 320, 640, 1000, 2000, 3000, 4000];
phi = [0.001, 0.016, 0.128];
Simulations = 1000;
% --------------------------- Simulate protocols ------------------------
for idx = 1:length(Nodes)
    N = Nodes(idx);        
    for i = 1:length(phi)
        p = phi(i);
        Sims_Opt(N, p, Simulations)
        Sims_Greedy(N, p, Simulations)
        Sims_Fixed(N, p, Simulations)
        Sims_Rule(N, p, Simulations)
        formatSpec = 'Completed for %d nodes with var of survival %.2f';
        str = sprintf(formatSpec, N, p)            
    end    
end 
% --------------------------- Plot Results ------------------------------
plot_results(Nodes, phi)