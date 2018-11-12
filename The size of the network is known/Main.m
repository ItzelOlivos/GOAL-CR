% -----------------------------------------------------------------------
% ----------------------------- Parameters ------------------------------
Nodes = [10, 20];
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
        Sims_Opt(N, p)
        Sims_Greedy(N, p)
        Sims_Fixed(N, p)
        Sims_Rule(N, p)
        formatSpec = 'Simulations for %d nodes is done';
        str = sprintf(formatSpec, N)            
    end   
end

plot_results(Nodes, lambda)