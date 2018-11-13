function [policy] = compute_policies(N, ps)
    
    [dist] = get_distribution(N, ps, 0:2*N);
    
    % ---------------------- Compute policies --------------------------
    Nmax = 2*N;
    prob_set = zeros(1, Nmax-1);
    for i = 0:1:Nmax-2
        prob_set(i + 1) = 1/(Nmax - i);    
    end    
    
    T = 5*N;
    
    distribution = zeros(length(dist), 2);
    optimal_prob_set = zeros(1, T);

    distribution(:,1) = dist;
    
    % -------------------- Start looping up T ---------------------    
    t = 1;
    while t <= T
        if mod(t,100) == 0
            t
        end
        % ---------------- Take greedy choice ---------------------
        p = get_greedy(prob_set, distribution(:, 1));    

        % --------------- Compute current distribution ------------
        for j = length(distribution(:, 1))-1:-1:1        
            A = (1 - j*p*(1-p)^(j-1)) * distribution(j, 1);
            B = ((j+1)*p*(1-p)^j) * distribution(j+1, 1);
            distribution(j,2) = A + B;
        end
        optimal_prob_set(t) = p;     
        % ------------------ Update Expectation -------------------
        
        distribution(:,1) = distribution(:,2);
        distribution(:,2) = 0;

        t = t + 1; 
    end
    
    policy = optimal_prob_set;        
    
    str = sprintf('Greedy_policies_vBinomial/OptimalPolicy_%d_%d', N, ps*1000);
    save(str, 'policy');