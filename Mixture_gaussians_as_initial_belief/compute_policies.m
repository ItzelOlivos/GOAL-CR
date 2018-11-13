function [policy] = compute_policies(span, mu1, mu2, sigma, prop1, prop2)
    
    [dist, obj] = get_distribution(mu1, mu2, sigma, prop1, prop2, 0:span, true);   
    
    % ---------------------- Compute policies --------------------------
    prob_set = zeros(1, span-1);
    for i = 0:1:span-2
        prob_set(i + 1) = 1/(span - i);    
    end    
    
    T = 5*span;
    
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
    
    str = sprintf('Greedy_policies_vMixture/OptimalPolicy_%d_%d_%d_%d_%d_%d', span, mu1, mu2, sigma, prop1, prop2);
    save(str, 'policy');