function [StatisticsDCF] = simulate_GrowthRule(policy, span, mu1, mu2, sigma, prop1, prop2, execs, saveme)

    % --- The simulation has a procedure to scape deadlock (dropme variable)
    % --- if more than 30 percent of the simulations are discarded due to
    % --- deadlock, then we assume that the protocol is not able to solve
    % --- the contention and we ignore the result.
    
    [dist, obj] = get_distribution(mu1, mu2, sigma, prop1, prop2, 0:span, false);   
    DCF = zeros(1, execs);

    N = [0:span]*dist;
    halt = ceil(exp(1)*N);
    Missing = zeros(1, execs);
    
    for e = 1:execs
        dropme = false;
        if mod(e, 100) == 0
            e
        end

        K = ceil(random(obj));

        t = 1;
        while K > 0
            wanting_nodes = 0;
            for idx = 1:K
                if t > halt
                    tao = policy(halt);
                else
                    tao = policy(t);
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
            if t > 3*N
                dropme = true;
                break
            end
        end
        if ~dropme
            DCF(e) = t;
        else
            Missing(e) = K;
        end
    end

    DCF = DCF(DCF>0);
    if length(DCF) > 0.7*execs
        m = mean(DCF);
        s = sqrt(var(DCF));
        min_value = min(DCF);
        max_value = max(DCF);
        t_value = 1.962;
        left = - t_value*s/sqrt(execs) + m;
        right = t_value*s/sqrt(execs) + m;
        StatisticsDCF = [m, s, mean(Missing), left, right, min_value, max_value];
    else
        StatisticsDCF = [3*N, 0, 0, 0, 0, 0];
    end

    if saveme
        str = sprintf('GrowthRule/Results_%d_%d_%d_%d_%d_%d', span, mu1, mu2, sigma, prop1, prop2);        
        save(str, 'StatisticsDCF');
    end
    