function [StatisticsDCF] = simulate_FixedOptimal(N, tao, execs)

    DCF = zeros(1, execs);

    for e = 1:execs
        if mod(e, 100) == 0
            e
        end

        K = N;

        t = 1;
        while K > 0
            wanting_nodes = 0;
            for idx = 1:K
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
    % t_value = 1.962;
    t_value = 1.98;
    left = - t_value*s/sqrt(execs) + m;
    right = t_value*s/sqrt(execs) + m;
    StatisticsDCF = [m, s, left, right, min_value, max_value];

    str = sprintf('FixedOptimalProbability/Results_%d', N);
    save(str,'DCF', 'StatisticsDCF');
