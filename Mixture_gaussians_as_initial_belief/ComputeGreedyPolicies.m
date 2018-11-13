% Create policies

nodes = 1000;

sep = [5, 10, 20, 40, 80, 160, 320];
mu1 = 500 - sep;
mu2 = 500 + sep;

sigma = 30; 
prop1 = 3;
prop2 = 2;

for idx = 1:length(nodes)
    N = nodes(idx);        
    for i = 1:length(mu1)
        m1 = mu1(i);
        m2 = mu2(i);
        compute_policies(N, m1, m2, sigma, prop1, prop2)
        formatSpec = 'Completed for %d nodes';
        str = sprintf(formatSpec, N)            
    end    
end