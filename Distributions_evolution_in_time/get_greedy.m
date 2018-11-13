function [p, EQcurrent] = get_greedy(N, num_nodes, prob_set, distribution)
    maxq = 0;    
    p = prob_set(1);
    
    for idx = 1:length(prob_set)
        tao = prob_set(idx);
        EQcurrent = 0;
        for n = 2:N + 2
            j = num_nodes(n);
            EQcurrent = EQcurrent + j * distribution(n, 1) * tao * (1-tao)^(j-1);            
        end
        if EQcurrent > maxq
            maxq = EQcurrent;
            p = tao;
        end           
    end
    EQcurrent = maxq;
end