function [StatisticsDCF] = Sims_Rule(N, ps)
    rng default  % For reproducibility

    str = sprintf('Greedy_policies_rule/OptimalPolicy_%d_%d', N, ps*1000);
    load(str);    
    alpha = coeffvalues(fitresult);

    % Params
    execs = 200;   % Number of executions of sims
    DCF = zeros(1, execs);

    for e = 1:execs
        if mod(e, 10) == 0
            e
        end

        K = binornd(N, ps);

        t = 1;    
        while K > 0
            wanting_nodes = 0;
            for idx = 1:K
                tao = min((1/N)*(alpha^t), 0.5);
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
    StatisticsDCF = [m, s, left, right, min_value, max_value]

    % formatSpec = '%f, %f, %f, %f, %f, %f\n';
    % fprintf(formatSpec, m, s, left, right, min_value, max_value)
    
    str = sprintf('Results/Rule/Results_%d_%d', N, ps*1000);
    save(str,'DCF', 'StatisticsDCF', 'ps');     