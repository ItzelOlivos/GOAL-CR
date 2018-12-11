function [optimal_unrestricted_prob_set] = compute_continuous_policies(N, ps)    
    
    T = N * 5;
    
    optimal_unrestricted_prob_set = zeros(1, T);
    
    sigma = ceil(ps*N/100); % por ciento de N
   [dist, obj] = get_distribution(N, sigma, 0:2*N);
   
    distribution = zeros(length(dist), 2);
    distribution(:,1) = dist;
    
    % ---------------------- Compute policies --------------------------

    t = 1;
    while t <= T
        if mod(t,100) == 0
            t
        end
        % ---------------- Take greedy choice ---------------------
        [p, fun] = get_continuous_greedy(N, distribution);    
        
        % --------------- Compute current distribution ------------
        for j = length(distribution(:, 1))-1:-1:1        
            A = (1 - j*p*(1-p)^(j-1)) * distribution(j, 1);
            B = ((j+1)*p*(1-p)^j) * distribution(j+1, 1);
            distribution(j,2) = A + B;
        end
        optimal_unrestricted_prob_set(t) = p;     
        % ------------------ Update Expectation -------------------
        distribution(:,1) = distribution(:,2);
        distribution(:,2) = 0;

        t = t + 1; 
    end
    
    str = sprintf('Greedy_Continuous_policies/OptimalPolicy_%d_%d', N, ps*1000);
    save(str, 'optimal_unrestricted_prob_set');
    