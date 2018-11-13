function [StatisticsDCF, acc] = Sims_Rule(span, mu1, mu2, sigma, prop1, prop2, execs)
    rng default  

    [dist, obj] = get_distribution(mu1, mu2, sigma, prop1, prop2, 0:span, false);   
    
    str = sprintf('Greedy_policies_rule_vMixture/OptimalPolicy_%d_%d_%d_%d_%d_%d', span, mu1, mu2, sigma, prop1, prop2);
    load(str);    
    alpha = coeffvalues(fitresult);

    % Params
    DCF = zeros(1, execs);

    for e = 1:execs
        if mod(e, 10) == 0
            e
        end
        flagme = false;
        K = ceil(random(obj));

        t = 1;    
        while K > 0
            wanting_nodes = 0;
            for idx = 1:K
                tao = min((1/span)*(alpha^t), 0.5);
                q = rand();                
                if q <= tao
                    wanting_nodes = wanting_nodes + 1;
                end
            end        
            if wanting_nodes == 1
                K = K - 1;
            end
            t = t + 1;             
            if t > 20*span
                flagme = true;
                break
            end
        end    
        if flagme
            DCF(e) = 0;    
        else
            DCF(e) = t;    
        end
    end 
    
    DCF = DCF(DCF > 0);
    acc = length(DCF)/execs;

    m = mean(DCF);
    s = sqrt(var(DCF));
    min_value = min(DCF);
    max_value = max(DCF);
    t_value = 1.962;
    left = - t_value*s/sqrt(execs) + m;
    right = t_value*s/sqrt(execs) + m;
    StatisticsDCF = [m, s, left, right, min_value, max_value]

    str = sprintf('Results/Rule/Results_%d_%d_%d_%d_%d_%d', span, mu1, mu2, sigma, prop1, prop2);
    save(str,'DCF', 'StatisticsDCF');     