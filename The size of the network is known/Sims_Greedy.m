function [StatisticsDCF, policies] = Sims_Greedy(N, ps)
    % Se asume sincronia de los nodos en el sentido de que todos conocen el
    % esquema de ranuras. C?mo? Al inicio pasan por una etapa de escucha en la
    % que aprenden c?anto duran las ranuras en el sistema y cu?ndo termin? la
    % ?ltima. El tiempo que les toma resolver esto sigue una distribuci?n
    % geom?trica.
    % The geometric distribution gives the probability that the first 
    % occurrence of success requires k independent trials, each with success probability p. 
    % async_starts are the number of slots without activity

    rng default                             % For reproducibility

    % Params

    execs = 200;                           % Number of executions of sims
    DCF = zeros(1, execs);
    
    str = sprintf('Greedy_policies/OptimalPolicy_%d_%d', N, ps*1000);
    load(str);    
    
    % plot(optimal_prob_set)    
    policies = policy;
    T = length(policy);
     
    for e = 1:execs
        if mod(e, 10) == 0
            e
        end
        K = binornd(N, ps);
        
        t = 1;    
        while K > 0
            wanting_nodes = 0;
            for idx = 1:K
                if t > T
                    tao = policies(T);                    
                else
                    tao = policies(t);                    
                end
                q = rand();
                if q <= tao
                    wanting_nodes = wanting_nodes + 1;
                end
            end        
            if wanting_nodes == 1
                K = K - 1;
            end
            t = t + 1;             
        end
        DCF(e) = t;                  
    end  

    m = mean(DCF);
    s = sqrt(var(DCF));
    min_value = min(DCF);
    max_value = max(DCF);
    t_value = 1.962;
    left = - t_value*s/sqrt(execs) + m;
    right = t_value*s/sqrt(execs) + m;
    StatisticsDCF = [m, s, left, right, min_value, max_value];

    str = sprintf('Results/Greedy/Results_%d_%d', N, ps*1000);
    save(str,'DCF', 'StatisticsDCF', 'ps');
