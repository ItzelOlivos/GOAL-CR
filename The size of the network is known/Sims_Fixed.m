function [StatisticsDCF, policies] = Sims_Fixed(Noriginal, ps)
    % Se asume sincronia de los nodos en el sentido de que todos conocen el
    % esquema de ranuras. C?mo? Al inicio pasan por una etapa de escucha en la
    % que aprenden c?anto duran las ranuras en el sistema y cu?ndo termin? la
    % ?ltima. El tiempo que les toma resolver esto sigue una distribuci?n
    % geom?trica.

    rng default  % For reproducibility
    
    % Params
    execs = 200;   % Number of executions of sims
    DCF = zeros(1, execs);
    
    N = ceil(ps*Noriginal);

    tao = ComputeConstantOptimal(N);    
    
    for e = 1:execs
        if mod(e, 10) == 0
            e
        end
        
        K = binornd(Noriginal, ps);
        
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
    t_value = 1.962;
    left = - t_value*s/sqrt(execs) + m;
    right = t_value*s/sqrt(execs) + m;
    StatisticsDCF = [m, s, left, right, min_value, max_value]

    % formatSpec = '%f, %f, %f, %f, %f, %f\n';
    % fprintf(formatSpec, m, s, left, right, min_value, max_value)
    
    str = sprintf('Results/Fixed/Results_%d_%d', Noriginal, ps*1000);
    save(str,'DCF', 'StatisticsDCF', 'ps');    
    