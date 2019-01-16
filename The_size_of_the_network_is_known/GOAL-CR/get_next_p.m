function [p] = get_next_p(prob_set, distribution)
    maxq = 0;
    p = prob_set(1);

    for idx = 1:length(prob_set)
        tao = prob_set(idx);
        EQcurrent = 0;
        for j = length(distribution):-1:1
            EQcurrent = EQcurrent + (j * tao * (1-tao)^(j-1)) * distribution(j, 1) ;
        end
        if EQcurrent > maxq
            maxq = EQcurrent;
            p = tao;
        end
    end
    EQcurrent = maxq;
end
