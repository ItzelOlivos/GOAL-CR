function [StatisticsDCF, policies] = simulate_ContinuousGOALCR(N, execs)

    % --- The simulation has a procedure to scape deadlock (dropme variable)
    % --- if more than 10 percent of the simulations are discarded due to
    % --- deadlock, then we assume that the protocol is not able to solve
    % --- the contention and we ignore the result.

    DCF = zeros(1, execs);

    str = sprintf('ContinuousGOAL-CR/OptimalPolicy_%d', N);
    load(str);

    policies = optimal_unrestricted_prob_set;
    T = length(policies);

    for e = 1:execs
        dropme = false;
        if mod(e, 100) == 0
            e
        end
        K = N;

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
            if t > 10*N
                dropme = true;
                break
            end
        end
        if ~dropme
            DCF(e) = t;
        end
    end

    DCF = DCF(DCF>0);
    if length(DCF) > 0.9*execs
        m = mean(DCF);
        s = sqrt(var(DCF));
        min_value = min(DCF);
        max_value = max(DCF);
        t_value = 1.962;
        left = - t_value*s/sqrt(execs) + m;
        right = t_value*s/sqrt(execs) + m;
        StatisticsDCF = [m, s, left, right, min_value, max_value];
    else
        StatisticsDCF = [0, 0, 0, 0, 0, 0];
    end

    str = sprintf('ContinuousGOAL-CR/Results_%d', N);
    save(str,'DCF', 'StatisticsDCF');
