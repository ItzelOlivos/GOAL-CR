% -----------------------------------------------------------------------
% ----------------------------- Parameters ------------------------------
Nodes = [10, 20, 40, 80, 160, 320, 640, 1000, 2000, 3000, 4000];
lambda = [1];
Simulations = 1000;
% ---------------------- Compute greedy polices -------------------------
for idx = 1:length(Nodes)
    N = Nodes(idx);        
    for i = 1:length(lambda)
        p = lambda(i);
        compute_policies(N, p)
        formatSpec = 'Computing greedy policy for %d nodes is done';
        str = sprintf(formatSpec, N)            
    end    
end
% ---------------------- Compute growth rule polices --------------------
for idx = 1:length(Nodes)
    N = Nodes(idx);        
    for i = 1:length(lambda)
        p = lambda(i);
        str = sprintf('Greedy_policies/OptimalPolicy_%d_%d', N, p*1000);
        load(str);  
        createFit(N, policy, p)
        formatSpec = 'Computing growth rule policy for %d nodes is done';
        str = sprintf(formatSpec, N)            
    end    
end
% --------------------------- Simulate protocols ------------------------
for idx = 1:length(Nodes)
    N = Nodes(idx);        
    for i = 1:length(lambda)
        p = lambda(i);
        Sims_Opt(N, p, Simulations)
        Sims_Greedy(N, p, Simulations)
        Sims_Fixed(N, p, Simulations)
        Sims_Rule(N, p, Simulations)
        formatSpec = 'Simulations for %d nodes is done';
        str = sprintf(formatSpec, N)            
    end   
end
% --------------------------- Plot Results -----------------------------

plot_results(Nodes, lambda)